# Xueqiu Article Generator Skill

This skill generates professional stock market analysis articles for Xueqiu (Snowball) platform based on the latest tech news and market data.

## Features

- Fetches latest technology and AI news using Tavily Search API
- Analyzes market impact and stock correlations  
- Generates articles in **dual format**:
  - **Markdown format**: Optimized for Xueqiu platform posting
  - **HTML/Docs format**: Professional web-ready documentation
- Uses optimized 3-section structure:
  - **事件深度解析** (Event Deep Analysis)
  - **对股票的结构性影响** (Structural Impact on Stocks)  
  - **结语** (Conclusion)
- Includes proper stock tags for Xueqiu platform
- Supports image integration for enhanced articles

## Usage

1. **Configure API Keys**:
   - Set `TAVILY_API_KEY` environment variable
   - Ensure Brave Search API key is configured for additional search capabilities

2. **Generate Article**:
   ```bash
   # Initialize configuration
   xueqiu-article-generator init
   
   # Generate article with default settings (outputs both .md and .html)
   xueqiu-article-generator generate
   
   # Generate article with custom topic (outputs both formats)
   xueqiu-article-generator generate "NVIDIA earnings AI chip demand"
   ```

3. **Output Files**:
   - `article_YYYYMMDD_HHMMSS.md` - Markdown format for Xueqiu
   - `article_YYYYMMDD_HHMMSS.html` - HTML format for web/docs

## Configuration

Create `.env` file in your workspace or use the built-in config:
```
TAVILY_API_KEY=your_tavily_api_key_here
OUTPUT_DIR=/path/to/output/directory
```

## Output Format

### Markdown Format (Xueqiu optimized)
- Clean, simple formatting suitable for Snowball platform
- Proper stock ticker formatting ($NVDA $AMD $TSM)
- Three-section structure for easy reading

### HTML/Docs Format (Web ready)
- Professional styling with proper typography
- Responsive design for mobile and desktop
- Enhanced readability with proper spacing and colors
- Ready to publish as standalone web page or documentation

## Requirements

- OpenClaw browser control enabled (optional for image capture)
- Tavily Search API key
- Internet connectivity for news fetching
- Basic HTML/CSS support for docs output

## Examples

```bash
# Generate NVIDIA-focused article (outputs both .md and .html)
xueqiu-article-generator generate "NVIDIA earnings AI chip demand"

# Generate semiconductor sector analysis
xueqiu-article-generator generate "semiconductor shortage AI chips"
```

## License

MIT License - Free to use and modify.