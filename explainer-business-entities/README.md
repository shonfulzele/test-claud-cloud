# Business Entities, Governance & Leverage — explainer video

A 13½-minute, 1920×1080 exam study-guide explainer covering §8 (business entities), §9 (governance, ownership and control) and §10 (leverage, supply chain, cognitive bias).

- **Narration:** Higgsfield Text-to-Speech V2 with the **Seed Speech** engine (the cheapest TTS option at 0.4 credits per line), voice "Julian". The full script is in [`script/TRANSCRIPT.md`](script/TRANSCRIPT.md).
- **Motion graphics:** hand-coded [HyperFrames](https://github.com/heygen-com/hyperframes) compositions animated with GSAP. Every layer, text element and keyframe is plain HTML/JS you can edit.
- **B-roll:** six 5-second **Kling 3.0 Turbo** clips, used only as cold-open plates: the intro, corporations, the boardroom, golf, the port and the brain.

## Layout

| Path | What it is |
|---|---|
| `index.html` | Master timeline: shared background, chapter HUD, progress bar, 27 scene slots and 27 voice-over tracks. **Generated**, so re-run `npm run build`. |
| `compositions/sNN.html` | One scene each. `const V` is when the voice starts in the scene and `const D` is the scene length. Every cue is `V + <word time>`, taken from the word-level transcript of that scene's audio. |
| `assets/theme.css` | Design tokens (colours, type) and shared components. Change a token here and every scene updates. |
| `script/scenes.json` | Narration text per scene, which is what the TTS voiced. |
| `script/timing.json` | Measured audio length plus lead-in and tail per scene. It drives `build-index.mjs`. |
| `script/fetch-media.sh` | Downloads the generated MP3s and Kling MP4s into `assets/`. |

## Build & render

```bash
npm install
npm run fetch      # voice-over + Kling clips (needs access to d8j0ntlcm91z4.cloudfront.net)
npm run build      # regenerate index.html from script/timing.json
npm run lint
npm run preview    # HyperFrames Studio: scrub, edit and retime in the browser
npm run render     # -> renders/explainer.mp4
```

## Editing tips

- **Retime a beat:** change the `V + n` number on that tween in the scene file.
- **Change a word on screen:** edit the HTML text. The layers are ordinary DOM elements with ids prefixed by the scene (`#s11-exam`, …).
- **Re-voice a scene:** regenerate it with Seed Speech, then update `audio` in `script/timing.json`, run `npm run build`, and update `const D` in that scene to the new value in `script/scene-times.json`.
