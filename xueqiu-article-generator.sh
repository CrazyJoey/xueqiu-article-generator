#!/bin/bash

# xueqiu-article-generator - 雪球文章生成器
# 基于最新科技新闻和市场数据，自动生成专业的雪球投资分析文章

set -e

# 配置文件路径
CONFIG_FILE="$HOME/.xueqiu-article-generator/config"
DEFAULT_CONFIG_FILE="$(dirname "$0")/default.config"

# 默认配置
DEFAULT_TAVILY_API_KEY=""
DEFAULT_OUTPUT_DIR="$HOME/Documents/xueqiu-articles"
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
    cat > "$CONFIG_FILE" << EOF
# xueqiu-article-generator 配置文件
# Tavily API Key (从 https://tavily.com 获取)
TAVILY_API_KEY="your_api_key_here"

# 输出目录
OUTPUT_DIR="$HOME/Documents/xueqiu-articles"

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
    
    echo "搜索最新科技新闻: $query"
    
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

# 生成文章草稿
generate_article_draft() {
    local news_data="$1"
    local max_length="$2"
    
    echo "生成文章草稿..."
    
    # 这里应该调用 AI 模型来生成文章
    # 由于我们是在脚本中，这里提供一个模板
    cat << EOF
**标题：基于最新科技新闻的投资分析**

**正文：**

根据最新科技新闻分析：

### 一、事件深度解析

[AI生成的内容]

### 二、对科技股的结构性影响

[AI生成的内容]
EOF

    if [ "$max_length" = "full_analysis" ]; then
        cat << EOF

### 三、重点标的分析与投资建议

[AI生成的内容]

### 四、投资策略建议

[AI生成的内容]

### 五、风险提示

[AI生成的内容]

### 六、结语

[AI生成的内容]
EOF
    fi
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
                echo "错误: 请先配置 Tavily API Key"
                echo "运行 'xueqiu-article-generator init' 来初始化配置"
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
            
            # 生成文章
            local article_file="$OUTPUT_DIR/article_$(date +%Y%m%d_%H%M%S).md"
            generate_article_draft "$news_data" "$MAX_LENGTH" > "$article_file"
            
            echo "文章已生成: $article_file"
            ;;
        "help"|*)
            cat << EOF
xueqiu-article-generator - 雪球文章生成器

用法:
  xueqiu-article-generator init          # 初始化配置文件
  xueqiu-article-generator generate      # 生成文章（使用默认查询）
  xueqiu-article-generator generate [查询关键词]  # 生成文章（使用自定义查询）

配置文件: $CONFIG_FILE
EOF
            ;;
    esac
}

main "$@"