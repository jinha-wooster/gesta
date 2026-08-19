#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/../site"
fail=0
for f in *.html; do
  python3 - "$f" <<'PY'
import re,sys
s=open(sys.argv[1]).read()
blocks=re.findall(r'<script>(.*?)</script>',s,re.S)
open('/tmp/_chk.js','w').write(blocks[-1] if blocks else '')
PY
  if [ -s /tmp/_chk.js ]; then
    node --check /tmp/_chk.js || { echo "SYNTAX FAIL: $f"; fail=1; }
  fi
  python3 -c "import sys;s=open(sys.argv[1],encoding='utf-8').read();sys.exit(1 if ('\u2014' in s or chr(0x2014) in s) else 0)" "$f" \
    || { echo "EM DASH FOUND: $f"; fail=1; }
done
python3 - <<'PY'
import os,re,sys
s=open('index.html').read()
links=[l for l in re.findall(r'href="([^"]+)"',s) if l.endswith('.html')]
missing=[l for l in links if not os.path.exists(l)]
if missing:
    print("BROKEN LINKS:",missing);sys.exit(1)
cards=len(re.findall(r'<a class="card"',s))
markers=len(re.findall(r'<a class="mk',s))
print(f"ok: {len(links)} links, {cards} cards, {markers} markers")
PY
exit $fail
