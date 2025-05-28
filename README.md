# Custom n8n with Puppeteer-Extra (External Browser)

This repository builds a custom Docker image for [n8n](https://n8n.io) with [`puppeteer-extra`](https://github.com/berstend/puppeteer-extra) and the stealth plugin pre-installed. It is optimized to use an **external browser service** (e.g., [Browserless](https://www.browserless.io/)), so no Chromium is bundled in the image.

## 🔧 Features

- Based on the latest **stable n8n release**
- Auto-builds hourly (only when upstream version changes)
- Publishes both versioned and `latest` tags to GHCR
- Ready for Code node automation with:
  - `puppeteer-extra`
  - `puppeteer-extra-plugin-stealth`

## 📦 Image

> **GHCR Repository:**  
> [`ghcr.io/mainto/n8n-puppeteer-extra`](https://ghcr.io/mainto/n8n-puppeteer-extra)

### Tags:

- `ghcr.io/mainto/n8n-puppeteer-extra:<version>`
- `ghcr.io/mainto/n8n-puppeteer-extra:latest`

## 🧑‍💻 Usage in n8n Code Node

```javascript
const puppeteer = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');

puppeteer.use(StealthPlugin());

(async () => {
  const browser = await puppeteer.connect({
    browserWSEndpoint: 'wss://your-browserless-url?token=your-token',
  });
  const page = await browser.newPage();
  await page.goto('https://example.com');
  const html = await page.content();
  await browser.disconnect();

  return [{ json: { html } }];
})();
