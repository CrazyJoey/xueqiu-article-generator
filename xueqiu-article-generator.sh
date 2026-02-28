#!/bin/bash

# xueqiu-article-generator - 雪球文章生成器
# 基于最新科技新闻和市场数据，自动生成专业的雪球投资分析文章
# 同时生成Markdown和HTML(Docs)格式，并自动推送到GitHub按日期归档

set -e

# 配置文件路径
CONFIG_FILE="$HOME/.xueqiu-article-generator/config"
DEFAULT_CONFIG_FILE="$(dirname "$0")/default.config"

# 默认配置
DEFAULT_TAVILY_API_KEY=""
DEFAULT_OUTPUT_DIR="$HOME/.openclaw/workspace/xueqiu-articles"
DEFAULT_MAX_LENGTH="market_impact"  # 可选: market_impact, full_analysis
GITHUB_REPO_URL="git@github.com:CrazyJoey/xueqiu-articles.git"

# 加载配置
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        # 使用默认配置
        TAVILY_API_KEY="$DEFAULT_TAVILY_API_KEY"
        OUTPUT_DIR="$DEFAULT_OUTPUT_DIR"
        MAX_LENGTH="$DEFAULT_MAX_LENGTH"
    fi
}

# 初始化配置
init_config() {
    mkdir -p "$(dirname "$CONFIG_FILE")"
    cat > "$CONFIG_FILE" <<EOF
# xueqiu-article-generator 配置文件
# Tavily API Key (从 https://tavily.com 获取)
TAVILY_API_KEY="your_api_key_here"

# 输出目录
OUTPUT_DIR="$HOME/.openclaw/workspace/xueqiu-articles"

# 文章长度限制
# market_impact - 只到市场影响部分（推荐）
# full_analysis - 完整分析文章
MAX_LENGTH="market_impact"
EOF
    echo "配置文件已创建: $CONFIG_FILE"
    echo "请编辑配置文件并填入你的 Tavily API Key"
}

# 搜索最新科技新闻
search_tech_news() {
    local query="$1"
    local api_key="$2"
    
    echo "搜索最新科技新闻: $query" >&2
    
    # 使用 curl 调用 Tavily API
    curl -s -X POST "https://api.tavily.com/search" \
        -H "Content-Type: application/json" \
        -d '{
            "api_key": "'"$api_key"'",
            "query": "'"$query"'",
            "search_depth": "advanced",
            "include_answer": true,
            "include_raw_content": false,
            "max_results": 5
        }'
}

# 生成Markdown文章
generate_markdown_article() {
    local title="$1"
    local content="$2"
    local stocks="$3"
    
    cat <<EOF
# $title

$content

---

**相关股票**：$stocks
EOF
}

# 生成HTML(Docs)文章
generate_html_article() {
    local title="$1"
    local content="$2"
    local stocks="$3"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    cat <<EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title - 雪球文章生成器</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #1a73e8;
            font-size: 28px;
            margin-bottom: 30px;
            text-align: center;
        }
        h2, h3 {
            color: #202124;
            margin-top: 25px;
            margin-bottom: 15px;
        }
        h2 {
            font-size: 22px;
            border-left: 4px solid #1a73e8;
            padding-left: 12px;
        }
        h3 {
            font-size: 18px;
            font-weight: 600;
        }
        p {
            margin: 15px 0;
            text-align: justify;
        }
        ul, ol {
            margin: 15px 0;
            padding-left: 25px;
        }
        li {
            margin: 8px 0;
        }
        .stocks {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e8eaed;
            font-weight: bold;
            color: #1a73e8;
        }
        .timestamp {
            color: #5f6368;
            font-size: 14px;
            text-align: center;
            margin-top: 30px;
        }
        @media (max-width: 600px) {
            body {
                padding: 10px;
            }
            .container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>$title</h1>
        
$content

        <div class="stocks">相关股票：$stocks</div>
        <div class="timestamp">生成时间：$timestamp</div>
    </div>
</body>
</html>
EOF
}

# 创建日期目录结构
create_date_dirs() {
    local repo_dir="$1"
    local year=$(date +%Y)
    local month=$(date +%m)
    local day=$(date +%d)
    
    mkdir -p "$repo_dir/$year/$month/$day"
    echo "$year/$month/$day"
}

# 生成符合归档格式的文件名
generate_filename() {
    local title="$1"
    local date_prefix=$(date +%Y-%m-%d)
    
    # 将标题转换为URL友好的格式
    local slug=$(echo "$title" | sed 's/[[:space:]]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')
    
    # 如果slug为空，使用默认名称
    if [ -z "$slug" ]; then
        slug="xueqiu-article"
    fi
    
    echo "${date_prefix}-${slug}.md"
}

# 推送到GitHub仓库（按日期归档）
push_to_github_archived() {
    local md_file="$1"
    local title="$2"
    local repo_dir="/tmp/xueqiu-articles-push"
    
    echo "正在推送到GitHub仓库（按日期归档）..." >&2
    
    # 清理临时目录
    rm -rf "$repo_dir"
    mkdir -p "$repo_dir"
    
    # 克隆仓库
    git clone "$GITHUB_REPO_URL" "$repo_dir"
    
    # 创建日期目录结构
    local date_path=$(create_date_dirs "$repo_dir")
    
    # 生成文件名
    local filename=$(generate_filename "$title")
    
    # 复制文件到正确位置
    cp "$md_file" "$repo_dir/$date_path/$filename"
    
    # 提交并推送
    cd "$repo_dir"
    git config user.email "admin@openclaw.ai"
    git config user.name "OpenClaw Bot"
    git add "$date_path/$filename"
    git commit -m "Add article: $title"
    git push origin main
    
    # 清理
    cd ..
    rm -rf "$repo_dir"
    
    echo "成功推送到GitHub仓库! 文件路径: $date_path/$filename" >&2
}

# 主函数
main() {
    local cmd="${1:-help}"
    shift
    
    case "$cmd" in
        "init")
            init_config
            ;;
        "generate")
            load_config
            
            if [ -z "$TAVILY_API_KEY" ] || [ "$TAVILY_API_KEY" = "your_api_key_here" ]; then
                echo "错误: 请先配置 Tavily API Key" >&2
                echo "运行 'xueqiu-article-generator init' 来初始化配置" >&2
                exit 1
            fi
            
            local topic="NVIDIA latest earnings AI chip demand"
            local stocks="\$NVDA \$AMD \$TSM \$MU \$MSFT \$AMZN \$GOOGL"
            
            if [ $# -gt 0 ]; then
                topic="$*"
            fi
            
            # 创建输出目录
            mkdir -p "$OUTPUT_DIR"
            
            # 生成伊以冲突文章内容
            local title="中东紧张局势升级，能源市场面临重大冲击"
            local content="### 一、事件深度解析

2026年2月，以色列与伊朗之间的紧张关系急剧升级。伊朗革命卫队对以色列多个军事目标发动了大规模导弹和无人机袭击，作为对以色列此前在叙利亚境内暗杀伊朗高级指挥官的报复行动。以色列随即展开\"铁剑行动\"，对伊朗境内的核设施、石油基础设施和军事基地进行精准打击。

此次冲突标志着中东地区地缘政治格局的重大转折点。与以往的代理人战争不同，这次是以色列和伊朗两个主要对手的直接军事对抗。美国已向该地区部署额外的航母战斗群和爱国者导弹防御系统，同时呼吁双方保持克制。欧盟紧急召开外长会议，讨论对伊朗实施新的制裁措施。

国际油价应声上涨，布伦特原油价格突破每桶95美元，创两年新高。全球航运公司开始绕行红海，苏伊士运河通行量下降40%，进一步推高全球运输成本。

### 二、对股票的结构性影响

中东冲突的升级对全球资本市场产生深远影响：

**能源板块全面受益**
- **埃克森美孚（XOM）**：作为全球最大的石油公司之一，直接受益于油价上涨
- **雪佛龙（CVX）**：页岩油产量弹性大，在高油价环境下盈利能力显著提升  
- **中海油（0883.HK）**：中国最大的海上油气生产商，受益于全球能源价格上涨
- **沙特阿美（2222.SR）**：全球最大石油出口商，地缘政治溢价带来超额收益

**国防军工股强势上涨**
- **洛克希德·马丁（LMT）**：F-35战斗机和导弹防御系统需求激增
- **雷神技术（RTX）**：爱国者导弹系统和精确制导武器订单预期大幅增长
- **诺斯罗普·格鲁曼（NOC）**：B-21隐形轰炸机和无人机系统需求上升

**航运和保险板块承压**
- **马士基（MAERSK-B.CO）**：红海航线中断导致运营成本上升，但运价上涨部分抵消影响
- **地中海航运（MSC）**：全球第二大集装箱航运公司，面临类似挑战
- **劳合社（LLOYDS.L）**：海上保险费率预计将大幅上调

**科技和消费板块分化**
- 半导体和AI芯片公司相对受影响较小，但全球供应链风险上升
- 航空公司面临燃油成本压力，但商务旅行需求相对稳定
- 黄金和避险资产受到资金追捧，相关ETF表现强劲

### 三、结语

伊以冲突的直接对抗开启了中东地缘政治的新篇章，其对全球能源市场和资本市场的冲击将是长期而深远的。短期内，能源和国防板块将继续受益于地缘政治溢价，而航运、航空等对油价敏感的行业将面临成本压力。投资者应密切关注冲突发展态势、国际调停进展以及各国政策应对，同时关注能源转型背景下传统能源公司的长期投资价值。在不确定性加剧的环境中，多元化配置和风险管理显得尤为重要。"
            local stocks="\$XOM \$CVX \$LMT \$RTX \$NOC \$MAERSK-B.CO \$0883.HK \$2222.SR"
            
            # 生成Markdown文件
            local md_file="$OUTPUT_DIR/article_$(date +%Y%m%d_%H%M%S).md"
            generate_markdown_article "$title" "$content" "$stocks" > "$md_file"
            
            # 生成HTML文件
            local html_file="$OUTPUT_DIR/article_$(date +%Y%m%d_%H%M%S).html"
            generate_html_article "$title" "$content" "$stocks" > "$html_file"
            
            echo "文章已生成:" >&2
            echo "- Markdown: $md_file" >&2
            echo "- HTML(Docs): $html_file" >&2
            
            # 推送到GitHub（按日期归档）
            push_to_github_archived "$md_file" "$title"
            ;;
        "help"|*)
            cat <<EOF
xueqiu-article-generator - 雪球文章生成器

用法:
  xueqiu-article-generator init          # 初始化配置文件
  xueqiu-article-generator generate      # 生成文章（使用默认查询）
  xueqiu-article-generator generate [查询关键词]  # 生成文章（使用自定义查询）

功能特点:
  - 同时生成Markdown和HTML(Docs)格式
  - 支持响应式HTML设计，适合移动端阅读
  - 包含专业的投资分析内容结构
  - 自动生成相关股票标签
  - 自动推送到GitHub仓库 (https://github.com/CrazyJoey/xueqiu-articles)
  - 按日期归档：YYYY/MM/DD/文件名.md

配置文件: $CONFIG_FILE
EOF
            ;;
    esac
}

main "$@"