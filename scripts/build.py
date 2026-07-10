#!/usr/bin/env python3
from __future__ import annotations

import os
import re
from html import escape as html_escape
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
from matplotlib import font_manager, rcParams
import yaml


ROOT = Path(__file__).resolve().parents[1]
WIKI_DIR = ROOT / "wiki"
CHART_DIR = ROOT / "assets" / "charts"
FRONT_MATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*(?:\n|$)", re.S)
SKIP_FILES = {"README.md", "_template.md"}
OEM_TIER_ORDER = [
    "第一梯队｜全球规模与智驾标杆",
    "第二梯队｜中国高阶智驾主力",
    "第三梯队｜海外主流智驾跟进",
    "第四梯队｜特色/区域/新势力样本",
    "未分级",
]
OEM_FAMILY_ORDER = [
    "中系｜中国品牌",
    "德系｜德国品牌",
    "日系｜日本品牌",
    "韩系｜韩国品牌",
    "美系｜美国品牌",
    "欧系其他｜欧洲品牌",
    "其他",
]
AD_CATEGORY_ORDER = [
    "Robotaxi",
    "Robotruck",
    "量产辅助驾驶",
    "Robobus/Robovan",
    "末端配送",
    "港口",
    "矿区",
    "全栈/多赛道",
    "芯片/计算平台",
    "传感器/激光雷达",
    "仿真/验证工具链",
    "其他",
]

PREFERRED_CJK_FONTS = [
    "PingFang SC",
    "Hiragino Sans GB",
    "Microsoft YaHei",
    "SimHei",
    "Noto Sans CJK SC",
    "Source Han Sans SC",
    "WenQuanYi Zen Hei",
]

rcParams["svg.fonttype"] = "none"


def configure_cjk_font() -> bool:
    available: dict[str, str] = {}
    for font_path in font_manager.findSystemFonts():
        try:
            name = font_manager.FontProperties(fname=font_path).get_name()
        except Exception:
            continue
        available.setdefault(name, font_path)

    for font_name in PREFERRED_CJK_FONTS:
        if font_name in available:
            rcParams["font.sans-serif"] = [font_name, "DejaVu Sans"]
            rcParams["axes.unicode_minus"] = False
            return True
    return False


HAS_CJK_FONT = configure_cjk_font()


def read_entities(kind: str) -> list[dict[str, Any]]:
    folder = WIKI_DIR / kind
    entities: list[dict[str, Any]] = []

    for path in sorted(folder.glob("*.md")):
        if path.name in SKIP_FILES:
            continue

        text = path.read_text(encoding="utf-8")
        match = FRONT_MATTER_RE.match(text)
        if not match:
            print(f"[WARN] {path.relative_to(ROOT)}: missing YAML front-matter")
            continue

        try:
            data = yaml.safe_load(match.group(1)) or {}
        except yaml.YAMLError as exc:
            print(f"[WARN] {path.relative_to(ROOT)}: YAML parse error: {exc}")
            continue

        if not isinstance(data, dict):
            print(f"[WARN] {path.relative_to(ROOT)}: YAML front-matter is not a mapping")
            continue

        data["_path"] = path
        entities.append(data)

    return entities


def is_blank(value: Any) -> bool:
    return value is None or value == "" or value == "~"


def format_value(value: Any) -> str:
    if is_blank(value):
        return "~"
    if isinstance(value, list):
        if not value:
            return "~"
        return " / ".join(format_value(item) for item in value)
    if isinstance(value, dict):
        if not value:
            return "~"
        return "; ".join(f"{key}: {format_value(item)}" for key, item in value.items())
    return str(value)


def escape_cell(value: Any) -> str:
    return format_value(value).replace("\n", "<br>").replace("|", "\\|")


def entity_link(readme_path: Path, entity: dict[str, Any], label_field: str) -> str:
    label = escape_cell(entity.get(label_field))
    rel_path = os.path.relpath(entity["_path"], readme_path.parent)
    return f"[{label}]({Path(rel_path).as_posix()})"


def logo_cell(entity: dict[str, Any]) -> str:
    logo_path = entity.get("车标")
    if is_blank(logo_path):
        return "~"
    label = format_value(entity.get("名称") or entity.get("英文名") or "车企")
    src = html_escape(format_value(logo_path), quote=True)
    alt = html_escape(f"{label}车标", quote=True)
    return f'<img src="{src}" alt="{alt}" width="42" style="max-height:42px;object-fit:contain;">'


def logo_block(entity: dict[str, Any]) -> str:
    logo_path = entity.get("车标")
    if is_blank(logo_path):
        return "~"
    label = format_value(entity.get("名称") or entity.get("英文名") or "车企")
    src = html_escape(format_value(logo_path), quote=True)
    alt = html_escape(f"{label}车标", quote=True)
    return f'<p><img src="{src}" alt="{alt}" width="96" style="max-height:96px;object-fit:contain;"></p>'


def make_table(headers: list[str], rows: list[list[Any]]) -> str:
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]
    if not rows:
        rows = [["~" for _ in headers]]
    for row in rows:
        lines.append("| " + " | ".join(escape_cell(cell) for cell in row) + " |")
    return "\n".join(lines)


def make_grouped_oem_table(readme: Path, entities: list[dict[str, Any]]) -> str:
    headers = [
        "车标",
        "车企",
        "国家",
        "类型",
        "核心品牌",
        "核心产品",
        "智驾方案",
        "销量好原因",
        "状态",
        "营收_亿元",
        "净利润_亿元",
    ]
    grouped: dict[str, list[dict[str, Any]]] = {tier: [] for tier in OEM_TIER_ORDER}
    for entity in entities:
        tier = entity.get("梯队") or "未分级"
        if tier not in grouped:
            grouped[tier] = []
        grouped[tier].append(entity)

    sections: list[str] = []
    for tier in OEM_TIER_ORDER + sorted(set(grouped) - set(OEM_TIER_ORDER)):
        members = grouped.get(tier) or []
        if not members:
            continue
        members.sort(key=lambda item: format_value(item.get("英文名") or item.get("名称")))
        rows = [
            [
                logo_cell(entity),
                entity_link(readme, entity, "名称"),
                entity.get("国家"),
                entity.get("类型"),
                entity.get("核心品牌"),
                entity.get("核心产品") or entity.get("代表车型"),
                entity.get("智驾方案"),
                entity.get("销量好原因"),
                entity.get("状态"),
                entity.get("营收_亿元"),
                entity.get("净利润_亿元"),
            ]
            for entity in members
        ]
        sections.append(f"### {tier}\n\n{make_table(headers, rows)}")
    return "\n\n".join(sections)


def oem_family(entity: dict[str, Any]) -> str:
    country = format_value(entity.get("国家"))
    if country == "中国":
        return "中系｜中国品牌"
    if country == "德国":
        return "德系｜德国品牌"
    if country == "日本":
        return "日系｜日本品牌"
    if country == "韩国":
        return "韩系｜韩国品牌"
    if country == "美国":
        return "美系｜美国品牌"
    if country in {"法国", "英国", "瑞典", "荷兰"}:
        return "欧系其他｜欧洲品牌"
    return "其他"


def make_oem_family_table(readme: Path, entities: list[dict[str, Any]]) -> str:
    headers = ["车标", "车企", "国家", "梯队", "核心品牌", "核心产品", "智驾方案", "销量好原因", "营收_亿元", "净利润_亿元"]
    grouped: dict[str, list[dict[str, Any]]] = {family: [] for family in OEM_FAMILY_ORDER}
    for entity in entities:
        grouped.setdefault(oem_family(entity), []).append(entity)

    sections: list[str] = []
    for family in OEM_FAMILY_ORDER:
        members = grouped.get(family) or []
        if not members:
            continue
        members.sort(key=lambda item: (format_value(item.get("梯队")), format_value(item.get("英文名") or item.get("名称"))))
        rows = [
            [
                logo_cell(entity),
                entity_link(readme, entity, "名称"),
                entity.get("国家"),
                entity.get("梯队"),
                entity.get("核心品牌"),
                entity.get("核心产品") or entity.get("代表车型"),
                entity.get("智驾方案"),
                entity.get("销量好原因"),
                entity.get("营收_亿元"),
                entity.get("净利润_亿元"),
            ]
            for entity in members
        ]
        sections.append(f"### {family}\n\n{make_table(headers, rows)}")
    return "\n\n".join(sections)


def ad_company_categories(entity: dict[str, Any]) -> list[str]:
    categories: list[str] = []
    segments = entity.get("赛道") if isinstance(entity.get("赛道"), list) else []
    company_type = format_value(entity.get("类型"))
    business = format_value(entity.get("主营业务"))

    for segment in segments:
        if segment in AD_CATEGORY_ORDER and segment not in categories:
            categories.append(segment)

    if company_type == "芯片" and "芯片/计算平台" not in categories:
        categories.append("芯片/计算平台")
    if company_type == "传感器" and "传感器/激光雷达" not in categories:
        categories.append("传感器/激光雷达")
    if ("仿真" in business or "验证" in business or "工具链" in business or "仿真工具" in segments) and "仿真/验证工具链" not in categories:
        categories.append("仿真/验证工具链")

    business_segments = [segment for segment in segments if segment in {"Robotaxi", "Robotruck", "量产辅助驾驶", "Robobus/Robovan", "末端配送", "港口", "矿区"}]
    if (company_type == "综合" or len(set(business_segments)) >= 3) and "全栈/多赛道" not in categories:
        categories.append("全栈/多赛道")

    return categories or ["其他"]


def make_ad_category_table(readme: Path, entities: list[dict[str, Any]]) -> str:
    headers = ["公司", "类型", "总部", "赛道", "主营业务", "合作车企", "状态"]
    grouped: dict[str, list[dict[str, Any]]] = {category: [] for category in AD_CATEGORY_ORDER}
    for entity in entities:
        for category in ad_company_categories(entity):
            grouped.setdefault(category, []).append(entity)

    sections: list[str] = []
    for category in AD_CATEGORY_ORDER:
        members = grouped.get(category) or []
        if not members:
            continue
        members.sort(key=lambda item: format_value(item.get("英文名") or item.get("名称")))
        rows = [
            [
                entity_link(readme, entity, "名称"),
                entity.get("类型"),
                entity.get("总部"),
                entity.get("赛道"),
                entity.get("主营业务"),
                entity.get("合作车企"),
                entity.get("状态"),
            ]
            for entity in members
        ]
        sections.append(f"### {category}\n\n{make_table(headers, rows)}")
    return "\n\n".join(sections)


def replace_auto_section(readme_path: Path, marker: str, content: str) -> None:
    text = readme_path.read_text(encoding="utf-8")
    pattern = re.compile(
        rf"<!-- AUTO:START {re.escape(marker)} -->(.*?)<!-- AUTO:END {re.escape(marker)} -->",
        re.S,
    )
    replacement = (
        f"<!-- AUTO:START {marker} -->\n"
        f"{content.rstrip()}\n"
        f"<!-- AUTO:END {marker} -->"
    )
    new_text, count = pattern.subn(replacement, text)
    if count == 0:
        print(f"[WARN] {readme_path.relative_to(ROOT)}: missing AUTO marker {marker}")
        return
    readme_path.write_text(new_text, encoding="utf-8")


def parse_number(value: Any) -> float | None:
    if is_blank(value):
        return None
    if isinstance(value, (int, float)):
        return float(value)
    if isinstance(value, str):
        cleaned = value.strip().replace(",", "")
        try:
            return float(cleaned)
        except ValueError:
            return None
    return None


def make_bar_chart(
    entities: list[dict[str, Any]],
    field: str,
    filename: str,
    zh_title: str,
    en_title: str,
    zh_xlabel: str,
    en_xlabel: str,
) -> None:
    points: list[tuple[str, float]] = []
    for entity in entities:
        if entity.get("状态") == "已退出":
            continue
        number = parse_number(entity.get(field))
        if number is None:
            continue
        label = format_value(entity.get("英文名") or entity.get("名称") or entity.get("赛道"))
        points.append((label, number))

    if not points:
        print(f"[INFO] {field}: no numeric data, skip {filename}")
        return

    points.sort(key=lambda item: item[1])
    labels = [item[0] for item in points]
    values = [item[1] for item in points]

    height = max(2.4, 0.55 * len(points) + 1.4)
    plt.figure(figsize=(8, height))
    bars = plt.barh(labels, values, color="#2563eb")
    title = zh_title if HAS_CJK_FONT else en_title
    xlabel = zh_xlabel if HAS_CJK_FONT else en_xlabel
    plt.title(title)
    plt.xlabel(xlabel)
    max_value = max(values)
    plt.xlim(0, max_value * 1.18 if max_value > 0 else 1)

    for bar, value in zip(bars, values):
        plt.text(
            bar.get_width(),
            bar.get_y() + bar.get_height() / 2,
            f" {value:g}",
            va="center",
            fontsize=9,
        )

    plt.tight_layout()
    output_path = CHART_DIR / filename
    plt.savefig(output_path, format="svg")
    plt.close()
    print(f"[OK] chart: {output_path.relative_to(ROOT)}")


def build_oems() -> list[dict[str, Any]]:
    entities = read_entities("oems")
    readme = WIKI_DIR / "oems" / "README.md"
    replace_auto_section(readme, "oems-table", make_grouped_oem_table(readme, entities))
    replace_auto_section(readme, "oems-family-table", make_oem_family_table(readme, entities))
    for entity in entities:
        replace_auto_section(entity["_path"], "oem-logo", logo_block(entity))
    make_bar_chart(
        entities,
        "年销量_万辆",
        "oems_年销量.svg",
        "车企年销量（万辆）",
        "OEM annual sales (10k units)",
        "年销量（万辆）",
        "Annual sales (10k units)",
    )
    return entities


def build_ad_companies() -> list[dict[str, Any]]:
    entities = read_entities("ad-companies")
    readme = WIKI_DIR / "ad-companies" / "README.md"
    headers = ["公司", "类型", "总部", "主营业务", "合作车企", "状态"]
    rows = [
        [
            entity_link(readme, entity, "名称"),
            entity.get("类型"),
            entity.get("总部"),
            entity.get("主营业务"),
            entity.get("合作车企"),
            entity.get("状态"),
        ]
        for entity in entities
    ]
    replace_auto_section(readme, "ad-companies-table", make_table(headers, rows))
    replace_auto_section(readme, "ad-companies-category-table", make_ad_category_table(readme, entities))
    make_bar_chart(
        entities,
        "营收_万元",
        "ad_companies_营收.svg",
        "自动驾驶公司营收（万元）",
        "AD company revenue (CNY 10k)",
        "营收（万元）",
        "Revenue (CNY 10k)",
    )
    make_bar_chart(
        entities,
        "最新估值_亿美元",
        "ad_companies_估值.svg",
        "自动驾驶公司最新估值（亿美元）",
        "AD company valuation (USD 100m)",
        "最新估值（亿美元）",
        "Valuation (USD 100m)",
    )
    make_bar_chart(
        entities,
        "车队规模",
        "ad_companies_车队规模.svg",
        "自动驾驶公司车队规模",
        "AD company fleet size",
        "车辆数",
        "Vehicles",
    )
    return entities


def build_segments() -> list[dict[str, Any]]:
    entities = read_entities("segments")
    readme = WIKI_DIR / "segments" / "README.md"
    headers = ["赛道", "等级", "运营环境", "商业化阶段", "赛博汽车评测角度", "赛博口径评分", "代表玩家"]
    rows = [
        [
            entity_link(readme, entity, "赛道"),
            entity.get("自动化等级"),
            entity.get("运营环境"),
            entity.get("商业化阶段"),
            entity.get("评价要求"),
            entity.get("雷达评分_分"),
            entity.get("代表玩家"),
        ]
        for entity in entities
    ]
    replace_auto_section(readme, "segments-table", make_table(headers, rows))
    return entities


def main() -> None:
    CHART_DIR.mkdir(parents=True, exist_ok=True)
    print("[BUILD] oems")
    build_oems()
    print("[BUILD] ad-companies")
    build_ad_companies()
    print("[BUILD] segments")
    build_segments()
    print("[DONE] av-industry-radar build complete")


if __name__ == "__main__":
    main()
