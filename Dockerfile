FROM n8nio/n8n:stable

USER root

# Install ffmpeg and clean up
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Only install puppeteer and plugins — no Chromium
RUN npm install -g puppeteer-core puppeteer-extra puppeteer-extra-plugin-stealth puppeteer-extra-plugin-user-data-dir puppeteer-extra-plugin-user-preferences

USER node
