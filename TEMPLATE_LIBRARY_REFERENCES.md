# VYRO AI — Template library and implementation references

## Included in this build

The web editor contains 63 original VYRO edit-style presets. Style presets map to controls already supported by this build: caption preset, caption animation, caption position/alignment, caption background, fade/no transition, aspect ratio, playback speed, zoom, and text colors. Two layout presets render blurred-background fill and two-person splits using the left and right halves of a wide source shot. The gallery also provides distinct mockup visualizations for clean, kinetic, glow, cinematic, news, retro, waveform, editorial, frame, and luxury styles. The gallery appears after analysis has produced clip candidates. Selecting a card applies its profile to the editor controls; users can then fine-tune and export.

These are VYRO-authored style profiles inspired by common short-form editing conventions. They are not copies of another product's proprietary templates, previews, or source code.

## Open-source references reviewed

- **Remotion Templates by React Video Editor (MIT):** https://github.com/reactvideoeditor/remotion-templates — documents 81 reusable animation components across charts/data, text, content animation, backgrounds, cinematic effects, transitions, logo/branding, intro/outro, and image/media. Useful future implementation reference. The current VYRO renderer does not include Remotion, so those components are not imported into this build.
- **Remotion ecosystem resources:** https://github.com/remotion-dev/remotion/blob/main/packages/docs/docs/resources.mdx — catalogue of templates, libraries and examples, including video editor/timeline components and social-video resources.
- **Cutawan:** https://github.com/JeremySNR/cutawan — reference for transcript-driven highlight discovery, clip review, self-contained hook/build/payoff selection and speaker-aware reframing. Review its current license before reusing code.
- **ShortsForge:** https://github.com/hashimamjad-dev/ShortsForge — reference for local Whisper transcription, local LLM highlight ranking, face tracking and vertical rendering. Review its current license before reusing code.
- **VideoHighlighter:** https://github.com/Aseiel/VideoHighlighter — reference for explainable multi-signal video analysis and local highlight detection. Licensed AGPL-3.0; do not copy code into VYRO without deciding whether its network-copyleft obligations are acceptable.

## Additional implementation references

- **FFmpeg filters:** https://ffmpeg.org/ffmpeg-filters.html — authoritative reference for crop, scale, zoompan, overlay, fade, subtitles, drawtext, concat and audio filter support used by the VYRO renderer.
- **FFmpeg subtitles filter:** https://ffmpeg.org/ffmpeg-filters.html#subtitles-1 — reference for rendering ASS/SRT captions inside an FFmpeg filtergraph.
- **FFmpeg drawtext filter:** https://ffmpeg.org/ffmpeg-filters.html#drawtext-1 — reference for text rendering, font selection, timing and basic text effects.
- **ASS/SSA subtitle format:** https://aegisub.org/docs/latest/ass_specs/ — useful reference for subtitle styles, alignment, positioning and override tags used in exported VYRO caption files.
- **Aegisub:** https://github.com/Aegisub/Aegisub — open-source reference for subtitle timing, style design and ASS rendering behavior.
- **whisper.cpp:** https://github.com/ggml-org/whisper.cpp — MIT-licensed C/C++ implementation of Whisper; reference for local speech recognition and word-level timestamps.
- **OpenAI Whisper:** https://github.com/openai/whisper — reference for model behavior, language detection and transcription terminology.
- **PySceneDetect:** https://github.com/Breakthrough/PySceneDetect — open-source scene-change detection reference for identifying cuts, transitions and edit points.
- **OpenCV:** https://github.com/opencv/opencv — Apache-2.0-licensed computer-vision library reference for crop analysis and face tracking workflows.
- **yt-dlp:** https://github.com/yt-dlp/yt-dlp — reference for YouTube media discovery and format selection. Review and keep third-party download rules in mind.
- **LosslessCut:** https://github.com/mifi/lossless-cut — GPL-licensed video trimming and export workflow reference.
- **Shotcut:** https://github.com/mltframework/shotcut — GPL-licensed desktop editor reference for timeline, resize, caption and export concepts.
- **Kdenlive:** https://invent.kde.org/multimedia/kdenlive — GPL-licensed non-linear editor reference for project structure, tracks and composition workflows.
- **Ollama API:** https://github.com/ollama/ollama — reference for local model serving and JSON chat requests used by VYRO semantic and optional visual ranking.
- **FastAPI:** https://github.com/fastapi/fastapi — reference for VYRO's Python API routing and background job implementation.
- **React:** https://github.com/facebook/react — reference for the component state and rendering model used by the web studio.
- **Vite:** https://github.com/vitejs/vite — reference for frontend development and production bundling.
- **Tailwind CSS:** https://github.com/tailwindlabs/tailwindcss — utility styling reference used in VYRO's gallery and editor UI.
- **Lucide:** https://github.com/lucide-icons/lucide — open-source icon set used by the web interface.

## Video-template design references

- **Preview-style categories:** clean, kinetic, glow, cinematic, news, retro, waveform, editorial, frame and luxury are VYRO-authored visual families. Their descriptions and color treatments are not copied from any third-party preset bundle.
- **Creator, podcast and education patterns:** templates map common short-form needs to the controls VYRO actually supports: caption position, alignment, background, animation, crop, aspect ratio, speed and zoom.
- **Motion tracking patterns:** smart follow, upper-body follow, full-body focus and gesture focus are based on digital crop and tracking concepts. VYRO does not synthesize a new camera view or infer edits that were not present in the source footage.
- **Broadcast and editorial patterns:** news, sports, documentary and interview presets use widely understood lower-thirds, score-strip, chapter-title and clean-caption conventions. These are implementation profiles, not copies of a broadcaster's branding or graphics package.
- **Accessibility:** caption templates prefer readable colors and controllable text sizes; the final design should still be reviewed by the creator for contrast, safe margins and platform-specific text limits.

## License and reuse checklist

Before adding code or assets from any reference:

1. Verify the repository's current license and any assets with separate licenses.
2. Preserve required notices and attribution.
3. Check for network-copyleft obligations before combining AGPL-licensed code.
4. Do not copy proprietary template previews, fonts, logos or brand identities.
5. Prefer original VYRO configurations and reimplement behavior from public specifications or permissive projects.

## Important implementation boundary

The 63 presets apply the controls implemented in the current VYRO renderer. They do not yet create 3D motion graphics, custom animated transitions, automatic B-roll insertion, picture-in-picture layouts, or Remotion compositions. The two-person split assumes the people are already positioned on opposite sides of the source frame; it does not detect or track them.

## Next renderer expansion

1. Add a Remotion-based composition renderer or equivalent FFmpeg filtergraph modules.
2. Implement reusable motion components: kinetic typography, word highlighting, lower thirds, title cards, quote cards, progress bars, waveform visualizers, and additional multi-person or picture-in-picture layouts.
3. Add transition modules: cross-dissolve, push, slide, iris, zoom-through, glitch and whip-pan.
4. Add per-template preview thumbnails rendered from the actual composition, not static marketing images.
5. Add a template schema version and migration tests so saved projects retain their look.
