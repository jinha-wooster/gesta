#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/../site"
fail=0
for f in *.html; do
  python3 - "$f" <<'PY' || fail=1
import re,sys
f=sys.argv[1]
s=open(f,encoding='utf-8').read()
ok=True
# 1. nothing may follow the closing html tag
if s.strip() and not s.strip().endswith('</html>'):
    print(f"ORPHANED CODE AFTER </html>: {f}");ok=False
# 2. no em dashes, literal or as JS escape
if '\u2014' in s or '\\u2014' in s:
    print(f"EM DASH FOUND: {f}");ok=False
# 3. every called function must be defined (catches lost chunks)
blocks=re.findall(r'<script>(.*?)</script>',s,re.S)
js=blocks[-1] if blocks else ''
open('/tmp/_chk.js','w').write(js)
if js:
    defined=set(re.findall(r'function (\w+)\(',js))
    assigned=set(re.findall(r'(?<![\w.])(\w+)\s*=[^=]',js))
    called=set(re.findall(r'(?<![\w.])([a-z]\w{2,})\(',js))
    known=set('''for while switch catch return typeof delete
      requestAnimationFrame setTimeout setInterval parseInt parseFloat
      isNaN alert prompt confirm fetch atob btoa'''.split())
    missing=sorted(called-defined-assigned-known)
    if missing:
        print(f"UNDEFINED FUNCTIONS in {f}: {missing}");ok=False
sys.exit(0 if ok else 1)
PY
  if [ -s /tmp/_chk.js ]; then
    node --check /tmp/_chk.js || { echo "SYNTAX FAIL: $f"; fail=1; }
  fi
done
python3 - <<'PY'
import os,re,sys
s=open('index.html').read()
links=[l for l in re.findall(r'href="([^"]+)"',s) if l.endswith('.html')]
missing=[l for l in links if not os.path.exists(l)]
if missing:
    print("BROKEN LINKS:",missing);sys.exit(1)
print(f"ok: {len(links)} links")
PY
exit $fail
