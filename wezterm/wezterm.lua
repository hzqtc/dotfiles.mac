-- Pull in WezTerm API
local wezterm = require 'wezterm'

-- Initialize actual config
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Appearance
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Regular" })
config.font_size = 13
config.line_height = 1.2
config.enable_tab_bar = false -- let tmux handle sessions
config.window_padding = {
  left = 0, right = 0, top = 0, bottom = 0
}
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.hide_mouse_cursor_when_typing = true
config.native_macos_fullscreen_mode = true
config.initial_rows = 38
config.initial_cols = 169

-- Better font rendering for Retina
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

-- Performance
config.animation_fps = 1
config.max_fps = 60
config.front_end = "WebGpu"
config.enable_scroll_bar = false

-- macOS Friendly Keybindings
config.keys = {
  { key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
  { key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
  { key = "q", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },
}

-- Default program (auto attach to tmux)
config.default_prog = { "/opt/homebrew/bin/fish", "-l", "-c", "tmux new -A -s default" }

return config
