-- Pull in WezTerm API
local wezterm = require 'wezterm'

-- Initialize actual config
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Appearance
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 13
config.allow_square_glyphs_to_overflow_width = "Always"
config.line_height = 1.1

-- Window
config.enable_tab_bar = false
config.window_padding = { left = 8, right = 8, top = 0, bottom = 0 }
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

-- Behavior
config.window_close_confirmation = "NeverPrompt"
config.hide_mouse_cursor_when_typing = true
config.native_macos_fullscreen_mode = true

-- Better font rendering for Retina
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

-- Performance
config.animation_fps = 1
config.max_fps = 60
config.front_end = "WebGpu"
config.enable_scroll_bar = false

-- Keybindings
config.keys = {
  { key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
  { key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
  { key = "q", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },
  { key = ",", mods = "CMD", action = wezterm.action.SendString("nvo " .. wezterm.config_file .. "\n") },
  { key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },
  { key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
  { key = "=", mods = "CMD", action = wezterm.action.IncreaseFontSize },
  { key = "F", mods = "CMD", action = wezterm.action.Search { CaseInSensitiveString = "" } }
}

-- Default program (auto attach to tmux)
config.default_prog = { "/opt/homebrew/bin/tmux", "new", "-A", "-s", "default" }

return config
