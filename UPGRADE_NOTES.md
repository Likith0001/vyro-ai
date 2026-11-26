# VYRO AI – editor upgrade notes

## Implemented in this update

- Added five native caption templates to the browser editor: Creator Bold, Neon Pop, Minimal Clean, Podcast, and Karaoke.
- Added word-level caption animation options: karaoke highlight, pop-in, bounce, and fade.
- Connected the selected caption animation to the FastAPI export request and FFmpeg ASS subtitle renderer.
- Added an optional smooth fade-in/fade-out transition for both video and audio during export.
- Kept the existing clip analysis, word-timestamp handling, trimming, splitting, reframing, rotation, speed controls, batch ZIP export, Android application, and Ollama-first semantic ranking implementation.
- Added backend validation and regression tests for the new export options.

## Verification

- Python backend unit tests: 15 passed.
- TypeScript project check: passed with the available TypeScript compiler.
- FFmpeg integration smoke test: generated valid MP4s for all four caption animation modes, with audio/video streams and fade transitions.
- A full Vite production bundle was not verified in the Linux build environment because the archived `node_modules` contains Windows-only optional native packages. Run `npm install` in `web/` on the target Windows machine before starting or building the frontend.

## Scope and limitations

- The new caption templates and transitions are implemented natively in VYRO. This update does not copy the OpusClip hosted MCP server, paid generation services, or the complete OpusClip Video Tools template catalogue.
- The existing semantic AI ranking remains transcript-based. It does not analyze facial expressions or visual events.
- Faster-Whisper runs locally and downloads its configured model on first analysis; FFmpeg remains required for video processing.

## AI highlight engine + YouTube URL import

- Added a YouTube-only URL import endpoint backed by `yt-dlp`; playlists and non-YouTube hosts are rejected. Install the updated `server/requirements.txt` before using URL import.
- Analysis now keeps up to 30 ranked, non-overlapping transcript-anchored candidates. Automatic mode selects the top 10; custom mode selects the requested count (1–30).
- The ranked shortlist is stored with the project so the user can inspect timestamps/reasons, select individual moments, and apply that selection to the editor.
- The scoring pipeline uses Faster-Whisper word-aligned transcription, FFmpeg scene and silence signals, and an optional local Ollama-first semantic reranker. Without a semantic provider, transparent signal scoring remains available; it does not claim to predict virality or infer visual emotion.
- YouTube downloading is intended for videos the user owns or is authorized to use. Availability may vary with YouTube restrictions and yt-dlp compatibility.

## Dependency upgrade review — 2026-11-17

### Current upgrade verification

- Frontend dependencies were updated within their current compatible ranges; Tailwind CSS was additionally upgraded from 3.4 to 4.3.5 with `@tailwindcss/vite`. `web/package-lock.json` was refreshed.
- Backend direct dependencies were updated in `server/requirements.txt`; Uvicorn was already current.
- `npm run build` passed after the Tailwind 4 migration.
- All 29 backend tests passed with `python -m unittest -v test_main`; `pip check` reported no broken requirements.
- The server virtual environment's pip was upgraded to 26.3; `pip check` still reports no broken requirements.
- The frontend and backend started successfully. The backend health endpoint returned HTTP 200 with FFmpeg, Whisper, and YouTube import available. The browser rendered the workspace and its project controls.
- Loading the workspace automatically queued analysis for its selected imported project. The temporary servers were stopped before analysis/export completed, to avoid running a long media job as part of this check. This was not a full media-processing end-to-end test.
- `npm run lint` could not run: Windows Application Control blocked Oxlint's native module. Do not bypass the machine policy; rerun lint in an approved environment.
- Tailwind CSS 4.3.5 was migrated to the dedicated Vite plugin after the compatible-version update.

### Tailwind CSS 4 migration

- Replaced the Tailwind v3 directives with `@import "tailwindcss";` and integrated Tailwind using `@tailwindcss/vite`.
- Moved the custom `glow` box-shadow token into the CSS `@theme` block and removed the obsolete JavaScript Tailwind and PostCSS configuration files.
- Removed the direct `autoprefixer` and `postcss` development dependencies; Tailwind v4 handles imports and vendor prefixing.
- Updated `outline-none` uses to `outline-hidden` to preserve the v3 forced-colors behavior.
- Tailwind v4 requires Safari 16.4+, Chrome 111+, or Firefox 128+. Keep v3.4 instead if older browser support is required.
- Verification passed: the production build includes representative template gradient utilities, the browser rendered the saved workspace and all four projects, the proxied API health check returned HTTP 200, and npm reported zero vulnerabilities.

### Dependency upgrade policy

- Treat lockfiles as the reproducible install source: commit `web/package-lock.json` with `package.json` changes and use `npm ci --include=optional` for clean installs.
- Keep Python application dependencies explicitly pinned in `server/requirements.txt`; review and update `yt-dlp` regularly because extractor compatibility can change frequently.
- Review dependency updates monthly and when a security fix is announced. Use `npm outdated` and a Python package/version audit to identify candidates, then check release notes and supported runtime versions before updating.
- Prefer patch/minor updates in routine maintenance. Handle major upgrades in isolated changes with migration notes and targeted regression checks.
- For each update, verify the frontend production build, lint where the host permits it, backend tests, Python dependency consistency, and a local API/UI smoke test. Run dependency vulnerability audits as part of the review.
- Do not commit generated `node_modules`, virtual environments, media, or runtime work files.
