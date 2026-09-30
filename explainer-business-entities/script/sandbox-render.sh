#!/usr/bin/env bash
# Render one part of the explainer on a fresh Linux box with network access, e.g. the Higgsfield sandbox.
#   bash sandbox-render.sh <part 1-4> <presigned PUT url for the part mp4>
# Concatenate part-1..4 afterwards (ffmpeg concat demuxer, -c copy) to get the full video.
set -euo pipefail
PART=$1; PUT=$2
cd "$HOME"
if ! command -v node >/dev/null || [ "$(node -p 'process.versions.node.split(".")[0]')" -lt 22 ]; then
  curl -fsSL https://nodejs.org/dist/v22.12.0/node-v22.12.0-linux-x64.tar.xz | tar -xJ
  export PATH="$HOME/node-v22.12.0-linux-x64/bin:$PATH"
fi
[ -d r ] || git clone -q --depth 1 -b claude/youthful-meitner-axz76q https://github.com/shonfulzele/test-claud-cloud.git r
cd r/explainer-business-entities
npm ci --silent --no-audit --no-fund
bash script/fetch-media.sh >/dev/null
node script/build-index.mjs --parts
npx hyperframes browser ensure >/dev/null
npx hyperframes render -c "part-$PART.html" -o "renders/part-$PART.mp4" --quiet
ls -la "renders/part-$PART.mp4"
curl -f -X PUT -H "Content-Type: video/mp4" --upload-file "renders/part-$PART.mp4" "$PUT" && echo UPLOADED
