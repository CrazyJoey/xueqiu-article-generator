# Xueqiu Article Generator

Generate professional stock market analysis articles for Xueqiu (Snowball) platform based on latest tech news and market data.

## Features

- Fetch latest tech/AI news using Tavily Search API
- Analyze market impact and stock correlations
- Generate professional investment analysis articles
- Auto-screenshot relevant news sources
- Format articles specifically for Xueqiu platform

## Requirements

- Tavily Search API key (TAVILY_API_KEY environment variable)
- OpenClaw with browser control enabled
- Internet access for news fetching

## Usage

```bash
# Generate article about latest AI news
xueqiu-article-generator --topic "AI military applications" --stocks "BABA,NTES,KWAI"

# Generate article with custom length
xueqiu-article-generator --topic "latest tech news" --max-sections 2
```

## Environment Variables

- `TAVILY_API_KEY`: Your Tavily Search API key
- `XUEQIU_USERNAME`: Your Xueqiu username (optional)

## Output

Generates:
- Formatted article text (stdout)
- News screenshots in ./screenshots/ directory
- Article metadata in JSON format