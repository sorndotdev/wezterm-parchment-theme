-- Parchment (UML) theme for WezTerm.
--
--   local wezterm = require 'wezterm'
--   local theme = wezterm.plugin.require 'https://github.com/sorndotdev/wezterm-parchment-theme'
--   local config = wezterm.config_builder()
--   theme.apply_to_config(config)
--   return config
--
-- See README.md for the available options.

local wezterm = require('wezterm')

local M = {}

local SCHEME_NAME = 'Parchment (UML)'

M.defaults = {
    -- Primary font, with fallbacks applied via wezterm.font_with_fallback.
    -- Set to nil to leave the font untouched.
    font = { 'Departure Mono', 'Hack Nerd Font', 'Menlo', 'Hiragino Sans GB', 'Heiti SC' },
    font_size = 15.0,
    line_height = nil,
    -- Apply the parchment window frame, tab bar, gradient and cursor.
    window_frame = true,
    tab_bar = true,
    gradient = true,
    cursor = true,
}

-- Locate this plugin's checkout so its bundled scheme can be loaded.
-- `debug` is not available in WezTerm's Lua sandbox, so this relies solely on
-- the plugin registry populated by wezterm.plugin.require().
local function plugin_dir()
    local ok, plugins = pcall(wezterm.plugin.list)
    if not ok or not plugins then
        return nil
    end
    for _, entry in ipairs(plugins) do
        if (entry.url or ''):find('wezterm-parchment-theme', 1, true) then
            return entry.plugin_dir
        end
    end
end

local function load_colors()
    local dir = plugin_dir()
    if not dir then
        return nil
    end
    local ok, colors = pcall(wezterm.color.load_scheme, dir .. '/colors/parchment.toml')
    if ok and colors then
        return colors
    end
end

local function merge(base, override)
    local out = {}
    for k, v in pairs(base) do
        out[k] = v
    end
    for k, v in pairs(override or {}) do
        out[k] = v
    end
    return out
end

--- Apply the Parchment theme to a config builder.
--- Accepts either apply_to_config(config, opts) or apply_to_config{ config = config, ... }.
---@param config table WezTerm config builder
---@param opts? table
function M.apply_to_config(config, opts)
    if config and config.config then
        opts = config
        config = opts.config
    end
    opts = merge(M.defaults, opts)

    -- Color scheme.
    local colors = load_colors()
    if colors then
        config.color_schemes = config.color_schemes or {}
        config.color_schemes[SCHEME_NAME] = colors
        config.color_scheme = SCHEME_NAME
    else
        wezterm.log_error('parchment-theme: could not load colors/parchment.toml')
    end

    -- Font.
    if opts.font then
        config.font = wezterm.font_with_fallback(opts.font)
    end
    if opts.font_size then
        config.font_size = opts.font_size
    end
    if opts.line_height then
        config.line_height = opts.line_height
    end

    local ui = {
        bg = '#EFE8D3',
        bg2 = '#E3D9BD',
        sel = '#D8CDA8',
        fg = '#0000C0',
        purple = '#7F0055',
        dim = '#808080',
        border = '#8A6D3B',
    }

    if opts.window_frame then
        config.window_frame = {
            font = wezterm.font((opts.font and opts.font[1]) or 'Departure Mono'),
            font_size = opts.font_size or 15.0,
            active_titlebar_bg = ui.bg,
            inactive_titlebar_bg = ui.bg,
            active_titlebar_fg = ui.fg,
            inactive_titlebar_fg = ui.dim,
            active_titlebar_border_bottom = ui.border,
            inactive_titlebar_border_bottom = ui.border,
            button_fg = ui.purple,
            button_bg = ui.bg,
            button_hover_fg = ui.bg,
            button_hover_bg = ui.purple,
        }
    end

    if opts.tab_bar then
        config.use_fancy_tab_bar = false
        config.tab_bar_at_bottom = true
        config.tab_max_width = 28
        config.show_new_tab_button_in_tab_bar = false
        config.colors = config.colors or {}
        config.colors.tab_bar = {
            background = ui.bg,
            active_tab = { bg_color = ui.sel, fg_color = ui.purple, intensity = 'Bold' },
            inactive_tab = { bg_color = ui.bg2, fg_color = ui.dim },
            inactive_tab_hover = { bg_color = ui.sel, fg_color = ui.fg },
            new_tab = { bg_color = ui.bg, fg_color = ui.dim },
            new_tab_hover = { bg_color = ui.sel, fg_color = ui.fg },
        }
    end

    if opts.gradient then
        config.window_background_gradient = {
            colors = { '#FFFEF8', '#FFFDE4' },
        }
    end

    if opts.cursor then
        config.default_cursor_style = 'BlinkingBlock'
        config.cursor_blink_rate = 1400
        config.cursor_blink_ease_in = 'EaseIn'
        config.cursor_blink_ease_out = 'EaseOut'
    end

    return config
end

return M
