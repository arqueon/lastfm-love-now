# YouTube Music Likes Sync

This workflow exports YouTube Music liked songs with `ytmusicapi`, normalizes them, then syncs reliable rows to Last.fm loved tracks.

## Limits and Practical Constraints

`ytmusicapi` exposes `get_liked_songs(limit=100)`. Internally it calls `get_playlist("LM", limit)`. `get_playlist()` supports `limit=None`, which retrieves all items through YouTube Music continuation pages. For thousands of likes, use:

```bash
./ytm-lastfm-sync export-liked --limit all
```

There is no stable public YouTube Music API quota for this unofficial endpoint. Treat it as best-effort:

- export to local JSON first;
- avoid re-exporting repeatedly;
- do not sync directly from YouTube Music to Last.fm without a saved export;
- sync Last.fm writes with throttling and checkpointing.

Last.fm can return rate limit error `29`. The sync command defaults to a `0.35s` delay between writes and stores successful items in SQLite so reruns skip already synced tracks.

## Setup

Install the scripts:

```bash
./install.sh
```

`ytm-lastfm-sync` is an `uv run --script` executable, so `uv` will install `ytmusicapi` in an isolated environment the first time it runs. This avoids writing into the system Python on distributions that enforce PEP 668.

Save YouTube OAuth client credentials in the existing config:

```bash
./ytm-lastfm-sync setup-youtube
```

Then create the `ytmusicapi` OAuth file:

```bash
~/.config/niri/scripts/ytm-lastfm-sync setup-oauth
```

As of ytmusicapi 1.12, OAuth requires a YouTube Data API OAuth client id and secret. ytmusicapi recommends an OAuth client ID of type `TVs and Limited Input devices`.

## Smoke Test

Start small:

```bash
./ytm-lastfm-sync export-liked --limit 25
./ytm-lastfm-sync sync --preview 25
```

If `export-liked` fails with HTTP 400 from YouTube Music, use the official YouTube Data API fallback:

```bash
./ytm-lastfm-sync export-youtube-liked --limit 25
./ytm-lastfm-sync sync --export exports/youtube_liked_videos.raw.json --preview 25
```

This fallback exports all liked YouTube videos, not only YouTube Music library songs. It marks `Artist - Topic` channels as ready and sends other videos to `review.csv`.

This creates:

```text
exports/ytmusic_likes.raw.json
exports/ytmusic_likes.normalized.csv
exports/ytmusic_likes.ready.csv
exports/ytmusic_likes.review.csv
```

Rows in `ready.csv` have enough metadata for a conservative Last.fm `track.love` call. Rows in `review.csv` need manual inspection.

## Full Export

```bash
./ytm-lastfm-sync export-liked --limit all
```

Fallback full export:

```bash
./ytm-lastfm-sync export-youtube-liked --limit all
```

For thousands of likes this may take a while. If it fails, rerun the command; it overwrites the local export.

## Dry Run

```bash
./ytm-lastfm-sync sync
```

Dry-run mode prints what would be loved and does not call Last.fm.

## Apply

Start with a small batch:

```bash
./ytm-lastfm-sync sync --apply --max-tracks 50
```

Then continue:

```bash
./ytm-lastfm-sync sync --apply
```

Checkpoint state is stored at:

```text
~/.config/niri/scripts/ytm-lastfm-sync.sqlite3
```

Reruns skip tracks already marked as `loved` in the checkpoint database.
