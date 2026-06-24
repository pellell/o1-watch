# o1 Watch

A polished, self-contained static single-page site profiling the 28 people behind
OpenAI o1 and what they work on now.

## Run it
Open `index.html` directly in a browser — no server, no build step, no network calls.

```
xdg-open index.html   # or just double-click it
```

## What's inside
- **Contributors** — cards grouped under Leadership (7) and Foundational (21), each
  with name, role, bio, X/blog/site link buttons (shown only when present), and the
  person's curated highlights. Includes a name/role/bio search box.
- **Latest posts** — a single combined feed built from every person's highlights,
  with a people rail / dropdown to filter down to one person. Labeled as curated
  highlights, not a live social feed.
- **About & influence** — the o1 influence summary: headline, summary, benchmark
  results (AIME, Codeforces, GPQA), ripple effects, and source links.

## Data
`data.json` is the source of truth (28 people + `influence` + `meta`). Its full
contents are embedded verbatim as raw JSON in `<script id="data" type="application/json">`
inside `index.html` so the page is fully offline. After editing `data.json`, re-copy
its contents into that block and run `./verify.sh` (expects `VERIFY_OK`).
