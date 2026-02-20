# espanso-config

Personal Espanso text expansion config. Works on macOS and Linux.

## Install

```bash
git clone https://github.com/alecvanderpoel/espanso-config
cd espanso-config
chmod +x install.sh
./install.sh
```

Symlinks `match/` and `config/` into your Espanso config directory. Existing config is backed up automatically.

## Update (on any machine)

```bash
cd ~/path/to/espanso-config
git pull
espanso restart
```

## Structure

| File | Contents |
|------|----------|
| `match/base.yml` | Personal info (name, etc.) |
| `match/ai.yml` | OpenClaw model shortcuts |
| `match/dates.yml` | Date/time format expansions |
| `match/emojis.yml` | Emoji and flag shortcuts |
| `match/japanese.yml` | Japanese phrases + kana charts |
| `match/obsidian.yml` | Obsidian wikilinks, note templates |
| `config/default.yml` | Global Espanso settings |

## Trigger conventions

| Prefix | Category |
|--------|----------|
| `:` | Dates, names, templates |
| `;` | Emojis, symbols |
| `/model` | AI model switches |
