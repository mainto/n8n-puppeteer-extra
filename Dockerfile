FROM n8nio/n8n:stable

USER root

# Only install puppeteer and plugins — no Chromium
RUN npm install -g puppeteer-extra puppeteer-extra-plugin-stealth

USER node
