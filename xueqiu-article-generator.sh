#!/bin/bash

# xueqiu-article-generator - 雪球文章生成器
# 基于最新科技新闻和市场数据，自动生成专业的雪球投资分析文章

set -e

# 配置文件路径
CONFIG_FILE="$HOME/.xueqiu-article-generator/config"
DEFAULT_CONFIG_FILE="$(dirname "$0")/default.config"

# 默认配置
DEFAULT_TAVILY_API_KEY=""
DEFAULT_OUTPUT_DIR="/home/admin/.openclaw/workspace/xueqiu-articles"
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
OUTPUT_DIR="/home/admin/.openclaw/workspace/xueqiu-articles"

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

# 生成优化后的文章草稿（简化结构）
generate_article_draft() {
    local topic="$1"
    local stocks="$2"
    
    echo "生成优化文章草稿..."
    
    # 创建简化结构的文章模板
    cat <<EOF
# 英伟达财报超预期，AI芯片需求持续强劲

### 一、事件深度解析

[在此处插入基于最新新闻的深度分析内容]

### 二、对股票的结构性影响

[在此处插入对相关股票的结构性影响分析]

### 三、结语

[在此处插入总结性观点]

---

**相关股票**：$stocks
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
                echo "错误: 请先配置 Tavily API Key"
                echo "运行 'xueqiu-article-generator init' 来初始化配置"
                exit 1
            fi
            
            local topic="NVIDIA latest earnings AI chip demand"
            local stocks="\$NVDA \$AMD \$TSM \$MU \$MSFT \$AMZN \$GOOGL"
            
            if [ $# -gt 0 ]; then
                topic="$*"
            fi
            
            # 创建输出目录
            mkdir -p "$OUTPUT_DIR"
            
            # 生成文章
            local article_file="$OUTPUT_DIR/article_$(date +%Y%m%d_%H%M%S).md"
            generate_article_draft "$topic" "$stocks" > "$article_file"
            
            echo "优化文章已生成: $article_file"
            ;;
        "help"|*)
            cat <<EOF
xueqiu-article-generator - 雪球文章生成器（优化版）

用法:
  xueqiu-article-generator init          # 初始化配置文件
  xueqiu-article-generator generate      # 生成文章（使用默认查询）
  xueqiu-article-generator generate [查询关键词]  # 生成文章（使用自定义查询）

文章结构：
  ### 一、事件深度解析
  ### 二、对股票的结构性影响  
  ### 三、结语

配置文件: $CONFIG_FILE
EOF
            ;;
    esac
}

main "$@"