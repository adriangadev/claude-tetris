# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Vanilla Tetris. HTML5 Canvas + CSS + JS. No dependencies, no build, no package.json, no tests.

## Run

```bash
open index.html          # macOS, just open the file
python3 -m http.server 8000   # or serve locally, then visit localhost:8000
```

No build/lint/test commands exist in this repo.

## Files

- `index.html` — DOM: `#board` canvas (300×600, 10×20 grid, `BLOCK`=30px), `#next-canvas` preview, HUD spans (`#score`/`#lines`/`#level`), `#overlay` for pause/game-over.
- `style.css` — dark/retro arcade theme.
- `game.js` — all game logic (~300 lines, single file, no modules).

If `COLS`, `ROWS`, or `BLOCK` change in `game.js`, update `#board` canvas `width`/`height` in `index.html` to match (`COLS × BLOCK`, `ROWS × BLOCK`).

## Architecture (game.js)

State is module-level globals (`board`, `current`, `next`, `score`, `lines`, `level`, `paused`, `gameOver`, `dropInterval`, `dropAccum`, `lastTime`, `animId`) — no classes, no state container.

- **Board**: `ROWS × COLS` matrix, each cell `0` (empty) or `1–7` (color index tied to piece type via `COLORS`/`PIECES`).
- **Pieces**: square matrices in `PIECES`. Rotation is `rotateCW` (transpose + reverse), not a lookup table.
- **Collision**: `collide(shape, ox, oy)` is the single source of truth, used by movement, rotation, ghost, and spawn-check.
- **Wall kicks**: `tryRotate` retries rotation at offsets `[0, -1, 1, -2, 2]` before giving up.
- **Game loop**: `requestAnimationFrame`-driven `loop(ts)` accumulates `dt` into `dropAccum`; drops one row and calls `lockPiece()` when `dropAccum >= dropInterval`.
- **Locking**: `lockPiece` → `merge()` (bakes piece into `board`) → `clearLines()` → `spawn()`.
- **Line clear**: `clearLines` scans bottom-up, splices full rows, unshifts empty rows; recomputes `level` (`floor(lines/10)+1`) and `dropInterval` (`max(100, 1000 - (level-1)*90)`).
- **Scoring**: `LINE_SCORES = [0,100,300,500,800]` × level; hard drop = 2 pts/cell dropped, soft drop = 1 pt/row.
- **Ghost piece**: `ghostY()` projects current shape straight down via `collide`; drawn at `globalAlpha=0.2`.
- **Game over**: triggered in `spawn()` when the newly spawned piece immediately collides.

Input is a single `keydown` listener (Arrow keys move/rotate/soft-drop, Space hard-drops, `P` pauses, `X` also rotates). `restartBtn` click calls `init()`.

To add a feature (e.g. hold piece, T-spin detection, DAS/ARR), extend this same event-driven structure rather than introducing new abstractions — the codebase intentionally stays single-file and dependency-free.
