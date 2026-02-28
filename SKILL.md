# Xueqiu Article Generator Skill

This skill generates professional stock market analysis articles for Xueqiu (Snowball) platform based on the latest tech news and market data.

## Features

- Fetches latest technology and AI news using Tavily Search API
- Analyzes market impact and stock correlations
- Generates professional, concise articles suitable for Xueqiu audience
- Includes proper risk disclaimers and stock tags
- Supports image capture from news sources for article illustration

## Usage

1. **Configure API Keys**:
   - Set `TAVILY_API_KEY` environment variable
   - Ensure Brave Search API key is configured for additional search capabilities

2. **Generate Article**:
   ```bash
   xueqiu-article-generator --topic "AI military ethics" --stocks "BABA,NTES,KWAI" --length short
   ```

3. **Capture News Images**:
   ```bash
   xueqiu-article-generator capture --urls "https://cnbc.com/article1,https://cnbc.com/article2"
   ```

## Configuration

Create `.env` file in your workspace:
```
TAVILY_API_KEY=your_tavily_api_key_here
```

## Output Format

Articles are generated in the following structure:
- **Title**: Catchy but professional headline
- **Introduction**: Latest news event with date and context
- **Deep Analysis**: Core conflict or market dynamics
- **Market Impact**: Short-term and long-term effects on stocks
- **Stock Tags**: Relevant stock symbols for Xueqiu platform

## Requirements

- OpenClaw browser control enabled
- Tavily Search API key
- Internet connectivity for news fetching

## Examples

```bash
# Generate AI-focused article
xueqiu-article-generator --topic "Anthropic Pentagon AI conflict" --stocks "09988.HK,0700.HK,09999.HK,01024.HK"

# Generate with image capture
xueqiu-article-generator --topic "AI military ethics" --capture-news true
```

## License

MIT License - Free to use and modify.