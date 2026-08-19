# GESTA format spec (binding)

## What an entry is
A single self-contained HTML file in site/, cloned structurally from
site/battle-of-zama-3d.html (battles) or site/the-odyssey-episode-one.html (sagas).
Clone the engine verbatim: CSS variables and layout, phases pills, three.js r128 from
cdnjs, instanced vertex-colored figures, screen-space ring picking (pickRing), the
formation-drag plane, the decision dock (#dock overlaid on the stage), the dialogue
layer (#vn, playScene, PT portrait builder), banners, counters, camera presets.
Never use localStorage. Never load libraries beyond three.js r128 and Google Fonts.

## Command grammar (agency in setup and orders, spectacle in resolution)
- Exactly one formation DRAG beat teaching the battle's spatial idea, with a live HUD readout.
- One or two field-order RING beats (gold = historical, red = counterfactual).
- Two or three card DECISIONS with counterfactuals that play out visually, then freeze
  with an honest lesson and a Rewind button. No fail states, no scores.
- Counterfactuals must be argued from period logic, never hindsight mockery.

## Dialogue standard (the Alesia lesson)
- A speaking scene within ONE tap of loading. Never let the opening run voiceless.
- Cast of 2-4: at least one historical subordinate with a bond choice (REL) that pays
  off with variant lines in the aftermath, and where fitting one enemy voice.
- Use documented lines and anecdotes wherever they exist, adapted, not invented over.
- Portraits via the PT() parametric builder. Names format: "Name \u00b7 role".

## Restraint doctrine
Atrocities, massacres, and executions are narrated, never depicted; state period logic
and modern judgment both; the fixed sentence "The catalogue does not look away from
what commands cost, or who pays them" may close such passages. No gore, no glorification.

## Prose rules
- NEVER use the em dash character anywhere. Use commas, colons, or periods.
- Aftermath must include: honest casualty figures with uncertainty, what the victory
  bought and unbought, one long-arc irony, and a closing transferable lesson.
- Footer cites primary sources and states the figure scale (MEN_PER).

## Index update procedure (site/index.html)
1. Card: insert an <a class="card"> in the single grid, with an original inline SVG
   card-art strip (340x120, muted palette) and tags. Keep all cards equal weight.
2. Map marker: project true coordinates with x=(lon+12)/157*1000, y=(62-lat)*8.6.
   Add the standard marker block (mk-lead, mk-hit r>=24, mk-pulse, mk-dot, mk-pill,
   text). If the dot or pill collides with an existing pill, MOVE the existing pill
   and its leader line; never overlap.
3. Increment the written count in the shelf-label span ("eleven" -> "twelve", etc).

## Validation
bash pipeline/validate.sh must exit 0: every script block passes node --check, every
index link resolves, marker and card counts are consistent.
