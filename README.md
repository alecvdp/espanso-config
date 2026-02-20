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

## Private snippets

Sensitive info (email, phone, etc.) lives in `match/private.yml` which is gitignored and never committed. On a new machine:

```bash
cp match/private.example.yml match/private.yml
# edit private.yml with your actual values
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
| `match/private.example.yml` | Template for personal info (copy → `private.yml`, gitignored) |
| `config/default.yml` | Global Espanso settings |

## Trigger conventions

| Prefix | Category |
|--------|----------|
| `:` | Dates, names, templates |
| `;` | Emojis, symbols |
| `/model` | AI model switches |
