# Xueqiu Article Generator

Generate professional stock market analysis articles for Xueqiu (Snowball) platform based on latest tech news and market data.

## Features

- 📰 **实时新闻获取**: 通过 Tavily API 获取最新科技和金融新闻
- 📊 **股票关联分析**: 自动关联相关港股/美股标的  
- ✍️ **专业内容生成**: 生成符合雪球平台风格的投资分析文章
- 🖼️ **自动截图**: 配合浏览器工具自动截取新闻配图（可选）
- 🔒 **简洁结构**: 三段式文章结构（事件解析、结构性影响、结语）
- **双格式输出**: 同时生成 Markdown (.md) 和 HTML (.html) 格式

## 文章结构

生成的文章采用简洁的三段式结构：
1. **事件深度解析** - 最新事件的核心要点和背景
2. **对股票的结构性影响** - 对相关产业链和股票的影响分析  
3. **结语** - 总结性观点和未来展望

## 输出格式

### Markdown 格式 (.md)
- 优化用于雪球平台发布
- 清晰、专业的格式化
- 正确的股票标签和结构

### HTML/文档格式 (.html)
- 网页就绪的文档格式
- 专业的 CSS 样式
- 适合文档或网页发布
- 响应式设计，适配移动端

## 要求

- Tavily Search API key (TAVILY_API_KEY 环境变量)
- OpenClaw 浏览器控制功能（可选，用于截图）
- 网络连接用于新闻获取

## 使用方法

```bash
# 生成基于最新AI新闻的雪球文章（同时输出 .md 和 .html）
xueqiu-article-generator --topic "NVIDIA earnings AI chips" --stocks "NVDA,AMD,TSM"

# 生成特定主题的文章
xueqiu-article-generator --topic "semiconductor shortage AI chips"
```

## 输出文件

生成以下文件：
- `article_YYYYMMDD_HHMMSS.md` - Markdown 格式，用于雪球
- `article_YYYYMMDD_HHMMSS.html` - HTML 格式，用于网页/文档
- 新闻截图在 ./screenshots/ 目录中（如果启用）

## 环境变量

需要配置以下环境变量：
- `TAVILY_API_KEY` - Tavily API 密钥

## 依赖

- OpenClaw browser 工具（用于截图，可选）
- Tavily Search API
- curl, jq, bash

## 许可证

MIT License