FROM n8nio/n8n:stable

USER root

# Install ffmpeg and clean up
RUN apk add --no-cache ffmpeg

# Only install puppeteer and plugins — no Chromium
RUN npm install -g puppeteer-core puppeteer-extra puppeteer-extra-plugin-stealth puppeteer-extra-plugin-user-data-dir puppeteer-extra-plugin-user-preferences

USER node
