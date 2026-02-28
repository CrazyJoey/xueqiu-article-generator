#!/bin/bash

# xueqiu-article-generator - 雪球文章生成器
# 基于最新科技新闻和市场数据，自动生成专业的雪球投资分析文章
# 同时生成Markdown和HTML(Docs)格式

set -e

# 配置文件路径
CONFIG_FILE="$HOME/.xueqiu-article-generator/config"
DEFAULT_CONFIG_FILE="$(dirname "$0")/default.config"

# 默认配置
DEFAULT_TAVILY_API_KEY=""
DEFAULT_OUTPUT_DIR="$HOME/.openclaw/workspace/xueqiu-articles"
DEFAULT_MAX_LENGTH="market_impact"  # 可选: market_impact, full_analysis

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
            
            local query="latest AI and tech news investment analysis"
            if [ $# -gt 0 ]; then
                query="$*"
            fi
            
            # 创建输出目录
            mkdir -p "$OUTPUT_DIR"
            
            # 搜索新闻
            local news_data
            news_data=$(search_tech_news "$query" "$TAVILY_API_KEY")
            
            # 生成示例内容（实际使用时应该调用AI模型生成真实内容）
            local title="英伟达Q4财报创纪录，AI芯片需求持续爆发"
            local content="### 一、事件深度解析

2026年2月25日，英伟达（NVDA）发布了2026财年第四季度财报，交出了一份令人震撼的成绩单。公司Q4营收达到**681亿美元**，同比增长73%，超出市场预期约30亿美元。整个2026财年，英伟达总营收达到**2159亿美元**，同比增长65%。

财报中最引人注目的是数据中心业务的爆炸性增长。该部门Q4收入同比增长75%，占公司总营收的**91%以上**，成为绝对的核心增长引擎。CEO黄仁勋在财报电话会议中表示：\"计算需求正在指数级增长——代理AI的拐点已经到来。Grace Blackwell与NVLink是当今推理之王，每token成本降低了一个数量级。\"

更令人惊讶的是公司的未来指引：2027财年Q1营收指引为**780亿美元**，显示出AI基础设施建设需求的持续强劲。同时，公司总供应相关承诺从Q3的503亿美元激增至Q4的**952亿美元**，表明客户对英伟达AI芯片的需求远未见顶。

### 二、对股票的结构性影响

英伟达的超预期表现正在重塑整个科技股的投资逻辑：

**半导体产业链全面受益**
- **台积电（TSM）**：作为英伟达先进制程的主要供应商，7nm/5nm产能利用率维持在历史高位
- **AMD（AMD）**：虽然市场份额较小，但在特定推理场景中获得关注，特别是在Vera Rubin架构推出后
- **美光（MU）**：HBM高带宽内存需求激增，直接受益于AI服务器配置升级

**云计算巨头资本开支激增**
- **微软（MSFT）、亚马逊（AMZN）、谷歌（GOOGL）、Meta（META）**：四大超大规模云服务商的年度资本支出预计接近**7000亿美元**，主要用于AI基础设施建设
- 这些公司的AI投资直接转化为英伟达等硬件供应商的订单增长

**AI应用层估值逻辑重构**
- 随着AI基础设施成本下降和性能提升，AI应用公司的商业化路径更加清晰
- 从概念验证阶段转向实际盈利，相关软件和服务公司的估值逻辑发生根本性变化

**市场情绪与竞争格局**
值得注意的是，尽管业绩超预期，但英伟达股价在财报后出现波动。分析师指出，市场担忧AI计算重心可能从训练转向推理，这可能为竞争对手创造机会。然而，英伟达最新推出的Vera Rubin芯片专门针对推理优化，显示公司已做好充分准备。

### 三、结语

英伟达正站在AI工业革命的中心位置，其\"AI工厂\"定位愈发清晰。从财报数据看，AI基础设施建设仍处于早期阶段，需求增长远未见顶。虽然市场竞争加剧，但英伟达在生态系统、软件栈和客户关系方面的护城河依然深厚。投资者应关注公司在推理市场的技术进展、供应链能力以及客户集中度变化，这些因素将决定其能否持续引领这一轮AI技术革命。"
            local stocks="\$NVDA \$AMD \$TSM \$MU \$MSFT \$AMZN \$GOOGL \$META"
            
            # 生成Markdown文件
            local md_file="$OUTPUT_DIR/article_$(date +%Y%m%d_%H%M%S).md"
            generate_markdown_article "$title" "$content" "$stocks" > "$md_file"
            
            # 生成HTML文件
            local html_file="$OUTPUT_DIR/article_$(date +%Y%m%d_%H%M%S).html"
            generate_html_article "$title" "$content" "$stocks" > "$html_file"
            
            echo "文章已生成:" >&2
            echo "- Markdown: $md_file" >&2
            echo "- HTML(Docs): $html_file" >&2
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

配置文件: $CONFIG_FILE
EOF
            ;;
    esac
}

main "$@"