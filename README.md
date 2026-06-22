# lastfm-love-now

Small Bash helper for Last.fm. It checks the track currently marked as `nowplaying` and marks it as loved with `track.love`. On desktop Linux it can show a notification with track title, artist, album, artwork, and a red heart.

## Requirements

- `bash`
- `curl`
- `jq`
- `md5sum`
- `notify-send` for desktop notifications, optional
- `xdg-open` for the interactive setup browser step, optional
- Python 3.10+ and `ytmusicapi` for YouTube Music import, optional

## Install

```bash
git clone https://github.com/arqueon/lastfm-love-now.git
cd lastfm-love-now
./install.sh
~/.config/niri/scripts/lastfm-love-now setup
```

The default install path is:

```text
~/.config/niri/scripts/lastfm-love-now
```

The default config path is:

```text
~/.config/niri/scripts/lastfm-love.env
```

## Last.fm API Setup

Create a Last.fm API application here:

```text
https://www.last.fm/api/account/create
```

Then run:

```bash
~/.config/niri/scripts/lastfm-love-now setup
```

The setup command asks for:

- Last.fm username
- API key
- API secret

Then it opens the Last.fm authorization URL, waits for you to approve it, exchanges the token for a session key, and saves it in the config file.

## Usage

Love the current track:

```bash
~/.config/niri/scripts/lastfm-love-now
```

Print the current track:

```bash
~/.config/niri/scripts/lastfm-love-now now
```

Run the auth flow manually:

```bash
~/.config/niri/scripts/lastfm-love-now auth-url
~/.config/niri/scripts/lastfm-love-now session TOKEN
```

Disable notifications:

```bash
LASTFM_LOVE_NOTIFY=0
```

Put that line in `~/.config/niri/scripts/lastfm-love.env`.

## Niri Keybind Example

Example `config.kdl` binding:

```kdl
Mod+Shift+L { spawn "~/.config/niri/scripts/lastfm-love-now"; }
```

## Notes

The config file contains API secrets and a Last.fm session key. Keep it out of Git. This repository includes only `lastfm-love.env.example`.

## YouTube Music Likes Sync

There is an optional Python helper for exporting YouTube Music liked songs and syncing them to Last.fm loved tracks:

```bash
python3 -m pip install --user -r requirements.txt
./install.sh
~/.config/niri/scripts/ytm-lastfm-sync setup-youtube
ytmusicapi oauth ~/.config/niri/scripts/ytmusic-oauth.json
~/.config/niri/scripts/ytm-lastfm-sync export-liked --limit 25
~/.config/niri/scripts/ytm-lastfm-sync sync
```

For full exports:

```bash
~/.config/niri/scripts/ytm-lastfm-sync export-liked --limit all
~/.config/niri/scripts/ytm-lastfm-sync sync --apply --max-tracks 50
~/.config/niri/scripts/ytm-lastfm-sync sync --apply
```

See [docs/ytmusic-sync.md](docs/ytmusic-sync.md) for limits, dry-run workflow, and checkpointing.
