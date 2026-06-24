#!/usr/bin/env bash
# Verification for the o1-watch static site build.
# Success criteria: a self-contained single-page site, data-driven from the
# 28-person dataset embedded inline, with two views (Contributors + Latest posts).
set -euo pipefail

test -f index.html || { echo "FAIL: index.html missing"; exit 1; }

# The full dataset must be embedded inline as RAW JSON so the page opens via
# file:// with no server. Expect: <script id="data" type="application/json">...</script>
python3 - <<'PY'
import re, json, sys
h = open('index.html', encoding='utf-8').read()
m = re.search(r'<script[^>]*id=["\']data["\'][^>]*>(.*?)</script>', h, re.S)
if not m:
    print('FAIL: no inline <script id="data" type="application/json"> block'); sys.exit(1)
try:
    data = json.loads(m.group(1))
except Exception as e:
    print('FAIL: inline data is not valid raw JSON:', e); sys.exit(1)
people = data.get('people', [])
n = len(people)
assert n == 28, f'FAIL: expected 28 people, got {n}'
# every person must carry the fields the UI binds to
need = {'name', 'section', 'role', 'bio', 'highlights'}
for p in people:
    miss = need - set(p)
    assert not miss, f"FAIL: {p.get('name','?')} missing fields {miss}"
assert sum(1 for p in people if p['section'] == 'Leadership') == 7, 'FAIL: leadership count'
assert sum(1 for p in people if p['section'] == 'Foundational') == 21, 'FAIL: foundational count'
print('OK: inline dataset has', n, 'people with required fields')
PY

# Two-view navigation must exist.
grep -Eqi 'latest' index.html || { echo "FAIL: no 'Latest posts' view"; exit 1; }
grep -Eqi 'contributor|profile' index.html || { echo "FAIL: no Contributors view"; exit 1; }

# The influence summary must be present somewhere on the page.
grep -Eqi 'reason|AIME|test-time' index.html || { echo "FAIL: no influence summary"; exit 1; }

echo "VERIFY_OK"
