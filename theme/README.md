# Theme switcher

One command switches the color scheme across kitty, Neovim, Quickshell, and Hyprland's borders:

```
theme-switch <name>
```

Currently supported: `gruvbox`, `catppuccin`, `nord`, `tokyonight`, `everforest`, `monokaipro`.

## How it works

- `~/.config/theme/current` — a one-line file naming the active scheme. Neovim reads this at startup to decide which colorscheme to apply.
- `~/.config/theme/schemes/<name>/colors.qml` — a Quickshell palette file for each scheme, using the shared role names (`bg0-4`, `fg0-4`, `red`/`green`/`yellow`/`blue`/`purple`/`aqua`/`orange`/`gray`, `accent`) that `~/.config/quickshell/config/Colors.qml` and all the bar QML expect.
- `~/.local/bin/theme-switch` — the switcher script. For a given `<name>` it:
  1. Writes `<name>` to `~/.config/theme/current`.
  2. If `<name>` is in the `KITTY_THEME_NAME` map, calls kitty's own `+kitten themes` kitten with the matching bundled kitty theme name and `--reload-in=all`, so every open kitty window repaints instantly. Otherwise, if `schemes/<name>/kitty.conf` exists, copies it straight over `~/.config/kitty/current-theme.conf` — kitty's `reload_config_on_change` (on by default) picks up the change and repaints just as fast.
  3. Copies `schemes/<name>/colors.qml` over `~/.config/quickshell/config/Colors.qml`. Quickshell live-reloads QML on file change, so the bar updates instantly too.
  4. If `schemes/<name>/hypr-colors.lua` exists and a Hyprland session is running (`$HYPRLAND_INSTANCE_SIGNATURE` is set), copies it over `~/.config/hypr/colors.lua` and runs `hyprctl reload`.
- `~/.config/nvim/lua/plugins/theme.lua` — declares one lazy.nvim plugin per scheme, all loaded eagerly (`lazy = false`) so every colorscheme is always available. Each plugin's `config` function only calls `vim.cmd.colorscheme(...)` if it's the one named in `~/.config/theme/current`.
- `~/.config/theme/schemes/<name>/hypr-colors.lua` — a Lua table with the same role names as `colors.qml` (just hex strings without the `#`, since Hyprland's `rgba(...)` wants raw hex). `~/.config/hypr/appearance.lua` does `local colors = require("colors")` and builds `general.col.active_border` (an `accent` → `blue` gradient) and `general.col.inactive_border` (`bg3`) from it — `colors.lua` is the file the switcher overwrites, exactly parallel to `Colors.qml` for Quickshell.
- `~/.config/zsh/completions/_theme-switch` — tab completion for `theme-switch`. It lists whatever directories exist under `~/.config/theme/schemes/`, so it never needs editing when a scheme is added or removed.

Kitty, Quickshell, and Hyprland pick up a switch immediately. Neovim only reads `~/.config/theme/current` at startup, so an already-running Neovim needs a restart (or `:colorscheme <name>` by hand) to match.

## Adding a new theme

Say you want to add `<name>`:

1. **Pick a kitty theme.** Check what kitty ships built in:
   ```
   kitty +kitten themes --dump-theme "<Theme Name>"
   ```
   If it prints a color list, that name works. Add it to the `KITTY_THEME_NAME` map near the top of `~/.local/bin/theme-switch`:
   ```bash
   [<name>]="<Theme Name>"
   ```
   If kitty doesn't ship the theme you want (e.g. Monokai Pro), skip the map entry and instead hand-write `~/.config/theme/schemes/<name>/kitty.conf` — a plain kitty color conf (`background`, `foreground`, `color0`-`color15`, `selection_*`, `cursor*`) sourced from the theme's own palette. The switcher automatically falls back to copying that file into `current-theme.conf` when there's no map entry for `<name>`. Prefer the kitten whenever a bundled theme exists, since it comes straight from the upstream source instead of being retyped by hand.

2. **Write `~/.config/theme/schemes/<name>/colors.qml`.** Copy an existing scheme file as a template and fill in the same property list (`bg0-4`, `fg0-4`, the eight accent colors, `accent`). Pull the hex values from the scheme's own canonical source (its GitHub repo's palette file) rather than guessing — a kitty theme dump (`--dump-theme`) is also a reliable source for the core 16 colors, but the `bg0-4`/`fg0-4` extended shades usually only exist in the theme's own docs or Neovim plugin source. Keep the bg scale ordered darkest → lightest and the fg scale brightest → dimmest, matching the existing files, so contrast stays consistent. Pick `accent` as whatever color is that theme's most recognizable signature color.

3. **Add a Neovim plugin block** in `~/.config/nvim/lua/plugins/theme.lua`, following the pattern of the existing entries: `lazy = false, priority = 1000`, and a `config` function that only calls `vim.cmd.colorscheme(...)` when `active == "<name>"`. Then install it:
   ```
   nvim --headless "+Lazy! sync" +qa
   ```

4. **Write `~/.config/theme/schemes/<name>/hypr-colors.lua`.** Same values as `colors.qml`, just as a Lua table with bare hex strings (no `#`). The quickest way is to derive it from the `colors.qml` you just wrote rather than retyping the palette by hand.

5. **Test it:**
   ```
   theme-switch <name>
   ```
   Check that kitty's background changed, `~/.config/quickshell/config/Colors.qml` has the new `bg0`, `hyprctl getoption general:col.active_border` shows the new gradient, and `nvim --headless -c 'lua print(vim.g.colors_name)' -c qa` prints the right colorscheme name after setting `~/.config/theme/current` to `<name>`.

No changes are needed for tab completion — it reads the `schemes/` directory listing directly.
