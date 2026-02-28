# Xueqiu Article Generator

Generate professional stock market analysis articles for Xueqiu (Snowball) platform based on latest tech news and market data.

## Features

- Fetch latest tech/AI news using Tavily Search API
- Analyze market impact and stock correlations
- Generate professional investment analysis articles
- **Dual format output**: Both Markdown (.md) and HTML (.html) formats
- Auto-screenshot relevant news sources (optional)
- Format articles specifically for Xueqiu platform

## Output Formats

### Markdown Format (.md)
- Optimized for Xueqiu platform posting
- Clean, professional formatting
- Proper stock tags and structure

### HTML/Docs Format (.html)
- Web-ready document format
- Professional styling with CSS
- Suitable for documentation or web publishing
- Responsive design for mobile viewing

## Requirements

- Tavily Search API key (TAVILY_API_KEY environment variable)
- OpenClaw with browser control enabled (optional for screenshots)
- Internet access for news fetching

## Usage

```bash
# Generate article about latest AI news (outputs both .md and .html)
xueqiu-article-generator --topic "NVIDIA earnings AI chips" --stocks "NVDA,AMD,TSM"

# Generate semiconductor sector analysis
xueqiu-article-generator --topic "semiconductor shortage AI chips"
```

## Output

Generates:
- `article_YYYYMMDD_HHMMSS.md` - Markdown format for Xueqiu
- `article_YYYYMMDD_HHMMSS.html` - HTML format for web/docs
- News screenshots in ./screenshots/ directory (if enabled)