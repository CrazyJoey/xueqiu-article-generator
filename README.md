# Xueqiu Article Generator

自动生成高质量雪球投资文章的技能，基于最新科技新闻和市场数据。

## 功能特点

- 📰 **实时新闻获取**：通过 Tavily API 获取最新科技和金融新闻
- 📊 **股票关联分析**：自动关联相关港股/美股标的
- ✍️ **专业内容生成**：生成符合雪球平台风格的投资分析文章
- 🖼️ **自动截图**：配合浏览器工具自动截取新闻配图
- 🔒 **风险控制**：包含完整的风险提示和免责声明

## 使用方法

```bash
# 生成基于最新AI新闻的雪球文章
xueqiu-article-generator --topic "AI military ethics" --stocks "09988,0700,NTES,01024"

# 生成特定主题的文章
xueqiu-article-generator --topic "semiconductor shortage" --stocks "SMCI,NVDA"
```

## 环境配置

需要配置以下环境变量：
- `TAVILY_API_KEY` - Tavily API 密钥
- `MATON_API_KEY` - Maton API 密钥（用于 Gmail 监控等）

## 依赖

- OpenClaw browser 工具（用于截图）
- Tavily Search API
- curl, jq, bash

## 示例输出

生成的文章包含：
- 吸引人的标题
- 最新事件深度解析
- 市场影响分析
- 相关股票关联
- 配图建议
- 风险提示

## 许可证

MIT License