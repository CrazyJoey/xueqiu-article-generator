# Xueqiu Article Generator Skill

This skill generates professional stock market analysis articles for Xueqiu (Snowball) platform based on the latest tech news and market data.

## Features

- Fetches latest technology and AI news using Tavily Search API
- Analyzes market impact and stock correlations  
- Generates concise articles with 3-section structure:
  - **事件深度解析** (Event Deep Analysis)
  - **对股票的结构性影响** (Structural Impact on Stocks)
  - **结语** (Conclusion)
- Includes proper stock tags for Xueqiu platform
- Supports image capture from news sources for article illustration

## Usage

1. **Configure API Keys**:
   - Set `TAVILY_API_KEY` environment variable
   - Ensure Brave Search API key is configured for additional search capabilities

2. **Generate Article**:
   ```bash
   xueqiu-article-generator --topic "NVIDIA earnings AI chips" --stocks "NVDA,AMD,TSM"
   ```

3. **Simple Usage**:
   ```bash
   # Initialize configuration
   xueqiu-article-generator init
   
   # Generate article with default settings
   xueqiu-article-generator generate
   
   # Generate article with custom topic
   xueqiu-article-generator generate "NVIDIA latest earnings"
   ```

## Configuration

Create `.env` file in your workspace or use the built-in config:
```
TAVILY_API_KEY=your_tavily_api_key_here
```

## Output Format

Articles follow the optimized 3-section structure:
- **事件深度解析**: Latest news event with date and context
- **对股票的结构性影响**: Market impact analysis on related stocks
- **结语**: Concise conclusion with investment perspective

## Requirements

- OpenClaw browser control enabled (optional for image capture)
- Tavily Search API key
- Internet connectivity for news fetching

## Examples

```bash
# Generate NVIDIA-focused article
xueqiu-article-generator generate "NVIDIA earnings AI chip demand"

# Generate semiconductor sector analysis
xueqiu-article-generator generate "semiconductor shortage AI chips"
```

## License

MIT License - Free to use and modify.