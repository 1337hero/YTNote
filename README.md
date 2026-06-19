# ytnote

Turn a YouTube video into a **timestamped transcript + AI research notes**, saved as one
plain-markdown file you fully own. Built for the "is this talk worth a deep read?" → "okay, give
me real notes" workflow — a step up from pasting a raw transcript into a chat window.

No server, no database, no HTML artifact. One `.md` file per video, readable in Obsidian or any
editor.

## What it does

```
url ─▶ yt-dlp metadata
    ─▶ transcript   (YouTube subtitles first; local fallback: Parakeet, or whisper.cpp)
    ─▶ clean [HH:MM:SS] markdown
    ─▶ research notes via the `claude` CLI   (skip with --no-notes)
```

For caption-less videos the local fallback defaults to **NVIDIA Parakeet-TDT** (English,
via whisper.cpp's parakeet-cli) — on an AMD R9700 it benched faster and more accurate than
whisper large-v3-turbo. Pass `--whisper` to use whisper.cpp instead (multilingual).

Each file has YAML frontmatter (id, title, channel, url, duration, transcript source) followed
by a `## Notes` section (TL;DR, key points, timestamped notable moments, terms/references) and a
de-duplicated `## Transcript`.

## Requirements

| tool | why | required? |
|------|-----|-----------|
| [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) | metadata, subtitle + audio download | **yes** |
| [`ffmpeg`](https://ffmpeg.org/) | resample audio for local transcription | yes (only on the local-fallback path) |
| `python3` (3.8+) | the CLI itself — standard library only, no pip installs | **yes** |
| [`claude`](https://docs.claude.com/en/docs/claude-code) CLI | generates the notes | only if you want notes (omit with `--no-notes`) |
| [`parakeet-cli`](https://github.com/ggml-org/whisper.cpp) + a Parakeet ggml model | local fallback for caption-less videos (English, default) | only for the fallback path |
| [`whisper`](https://github.com/ggml-org/whisper.cpp) (whisper.cpp) + a ggml model | local fallback alternative (`--whisper`, multilingual) | only if you use `--whisper` |

If a video has YouTube captions and you pass `--no-notes`, you need just `yt-dlp` + `python3`.

### Arch Linux

```sh
sudo pacman -S yt-dlp ffmpeg python
# whisper.cpp + claude CLI: see their upstream install docs
```

## Install

```sh
git clone https://github.com/1337hero/YTNote.git
cd YTNote
chmod +x ytnote
```

Put it on your `PATH` (symlink `ytnote` into `~/.local/bin/`), or source the included shell
wrapper for `ytn` / `ytnt` shortcuts:

```sh
# in ~/.zshrc or ~/.bashrc
source /path/to/ytnote/ytnote.zsh
```

## Usage

```sh
ytnote "https://www.youtube.com/watch?v=VIDEO_ID"   # transcript + notes -> ./slug-id.md
ytnote --no-notes URL                               # transcript only (fast, no claude)
ytnote --parakeet URL                               # force local Parakeet, ignore captions
ytnote --whisper URL                                # local fallback via whisper.cpp instead
ytnote --dir ~/research URL                         # write into a library dir
ytnote --lang es URL                                # non-English (subtitles / whisper)
```

### Options

| flag | default | meaning |
|------|---------|---------|
| `--dir DIR`    | `$YTNOTE_DIR` or cwd | output directory |
| `--lang LANG`  | `en` | subtitle / whisper language |
| `--no-notes`   | off  | transcript only, skip claude |
| `--parakeet`   | off  | force local Parakeet transcription, ignore captions |
| `--whisper`    | off  | use whisper.cpp (not Parakeet) for local transcription |
| `--model PATH` | per-engine default | override the local model path |

### Environment

- `YTNOTE_DIR` — default output directory (point it at your notes library).
- `YTNOTE_PARAKEET_MODEL` — default Parakeet model path.
- `YTNOTE_WHISPER_MODEL` — default whisper.cpp model path.

## Output shape

```markdown
---
id: aircAruvnKk
title: "But what is a neural network? | Deep learning chapter 1"
channel: "3Blue1Brown"
url: https://www.youtube.com/watch?v=aircAruvnKk
duration: 00:18:40
transcript_source: subtitles
created: '2026-06-18'
---

# But what is a neural network? | Deep learning chapter 1

## Notes
**TL;DR** ...
**Key points** ...
**Notable moments** - [00:05:48] ...

## Transcript
[00:00:04] This is a 3.
[00:00:06] It's sloppily written ...
```

## Credits

Inspired by dair-ai's
[youtube-notetaker skill](https://github.com/dair-ai/dair-academy-plugins/tree/main/plugins/youtube-notetaker).
This is a leaner, CLI-first take: transcript + notes only, no slide extraction or bundled server.

## License

[MIT](LICENSE)
