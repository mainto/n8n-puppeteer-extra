FROM n8nio/n8n:stable

USER root

# Install ffmpeg and clean up
# RUN apk add --no-cache ffmpeg

RUN ARCH=$(uname -m) && \
    wget -qO- "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk && \
    ./sbin/apk.static -X https://dl-cdn.alpinelinux.org/alpine/latest-stable/main \
        -U --allow-untrusted add apk-tools && \
    rm -rf sbin apk-tools-static-*.apk && \
	apk --no-cache add ffmpeg sed

# --- PATCH: force YouTube resumable upload content-type to video/mp4 ---
RUN set -eux; \
  FILE="$(find /usr/local/lib/node_modules -type f -name 'YouTube.node.js' | head -n 1)"; \
  if [ -z "$FILE" ]; then \
    echo "ERROR: YouTube.node.js not found"; \
    exit 1; \
  fi; \
  echo "Patching: $FILE"; \
  \
  # Find the exact line that sets X-Upload-Content-Type (should be exactly one)
  MATCH_COUNT="$(grep -c "X-Upload-Content-Type" "$FILE" || true)"; \
  if [ "$MATCH_COUNT" -ne 1 ]; then \
    echo "ERROR: Expected exactly 1 occurrence of X-Upload-Content-Type but got $MATCH_COUNT"; \
    echo "---- context ----"; \
    grep -n "X-Upload-Content-Type" "$FILE" || true; \
    exit 1; \
  fi; \
  \
  # Patch ONLY the value part to 'video/mp4' (keep formatting as much as possible)
  cp "$FILE" "$FILE.bak"; \
  sed -i -E "s/('X-Upload-Content-Type':[[:space:]]*)[^,}]+/\\1'video\\/mp4'/" "$FILE"; \
  \
  # Verify patch applied
  if ! grep -q "'X-Upload-Content-Type': 'video/mp4'" "$FILE"; then \
    echo "ERROR: Patch verification failed"; \
    echo "---- patched line ----"; \
    grep -n "X-Upload-Content-Type" "$FILE" || true; \
    exit 1; \
  fi; \
  echo "Patch OK"; \
  grep -n "X-Upload-Content-Type" "$FILE"
# --- /PATCH ---

# Only install puppeteer and plugins — no Chromium
RUN npm install -g puppeteer-core puppeteer-extra puppeteer-extra-plugin-stealth puppeteer-extra-plugin-user-data-dir puppeteer-extra-plugin-user-preferences

USER node
