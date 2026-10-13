# wezterm-parchment-theme

A warm parchment light theme for [WezTerm](https://wezterm.org): a custom color
scheme plus the font, window frame, tab bar and cursor styling that go with it.

![icon](assets/terminal_icon.png)

## Install

It is an ordinary WezTerm plugin (a Git repo with `plugin/init.lua`):

```lua
-- ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local theme = wezterm.plugin.require 'https://github.com/sorndotdev/wezterm-parchment-theme'

local config = wezterm.config_builder()
theme.apply_to_config(config)
return config
```

It is registered on first use; run `wezterm.plugin.update_all()` (e.g. from the
debug overlay) to pull later changes.

## Font

The theme's primary font is [Departure Mono](https://departuremono.com/), which
is **not** bundled. Install it, or it will fall back to `Hack Nerd Font`,
`Menlo`, and the CJK fallbacks. Override with the `font` option:

```lua
theme.apply_to_config(config, {
  font = { 'Iosevka', 'Hack Nerd Font' },
  font_size = 14.0,
})
```

## Options

| Option | Default | Description |
| --- | --- | --- |
| `font` | `{ 'Departure Mono', 'Hack Nerd Font', 'Menlo', 'Hiragino Sans GB', 'Heiti SC' }` | Primary font plus fallbacks. `nil` leaves the font untouched. |
| `font_size` | `15.0` | Font size. |
| `line_height` | `nil` | Optional `line_height`. |
| `window_frame` | `true` | Apply the parchment title-bar/frame colors. |
| `tab_bar` | `true` | Apply the retro tab bar styling. |
| `gradient` | `true` | Apply the background gradient. |
| `cursor` | `true` | Apply the blinking-block cursor. |

Anything you set on `config` after `apply_to_config` wins.

## Using just the color scheme

The scheme is a standalone WezTerm TOML file at `colors/parchment.toml`, so it
works without the plugin too:

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local colors = wezterm.color.load_scheme(
  wezterm.home_dir .. '/path/to/wezterm-parchment-theme/colors/parchment.toml')
config.color_schemes = { ['Parchment (UML)'] = colors }
config.color_scheme = 'Parchment (UML)'

return config
```

Or copy `colors/parchment.toml` into a directory and point
`config.color_schemes_dir` at it to select it by name.

## Layout

```
plugin/init.lua        # the plugin entry point (apply_to_config)
colors/parchment.toml  # standalone color scheme
assets/terminal_icon.png
```

## License

MIT. See `LICENSE`.
