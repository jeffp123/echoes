#!/bin/sh
# Tell IndexNow (Bing, Yandex, and others) which pages changed. Run after each deploy:
#   scripts/indexnow.sh                      # pings every URL in sitemap.xml
#   scripts/indexnow.sh https://echoesdaily.app/changelog/   # or just the pages you changed
set -e
KEY=cca8b136840f1de011c93a42028e6e1a
cd "$(dirname "$0")/.."
if [ $# -gt 0 ]; then URLS="$*"; else URLS=$(sed -n 's#.*<loc>\(.*\)</loc>.*#\1#p' sitemap.xml); fi
LIST=$(printf '"%s",' $URLS | sed 's/,$//')
curl -sS -o /dev/null -w "IndexNow: HTTP %{http_code}\n" -X POST https://api.indexnow.org/indexnow \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "{\"host\":\"echoesdaily.app\",\"key\":\"$KEY\",\"keyLocation\":\"https://echoesdaily.app/$KEY.txt\",\"urlList\":[$LIST]}"
