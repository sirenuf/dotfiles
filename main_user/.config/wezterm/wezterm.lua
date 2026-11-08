local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local fonts =
{
  { family = "Terminus" },
  { family = "Symbols Nerd Font Mono", scale = 0.5 }
}

local main_font = {}
    main_font.font = {
      fonts = fonts
    }
    main_font.wez_font_fallback = wezterm.font_with_fallback(main_font.font.fonts)

local bold_font = {}
    bold_font.font = {
      fonts = fonts,
      settings = {
        weight     = "Bold",
        foreground = "#eeeeec"
      }
    }
    bold_font.wez_font_fallback = wezterm.font_with_fallback(bold_font.font.fonts, bold_font.font.settings)
    bold_font.font_rule = {
      intensity = "Bold",
      italic    = false,
      font      = bold_font.wez_font_fallback
    }

config.font = main_font.wez_font_fallback

config.bold_brightens_ansi_colors = "No"
config.font_rules =
{
  --> Rule:
  --> When fonts are bold, only foreground (white) text will be intensified.
  bold_font.font_rule
}


config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.85
config.colors = {
  foreground = '#babdb6',
  background = '#000000',

  cursor_bg = "white",
  cursor_fg = "black",
  cursor_border = "white",

  ansi = { '#000000', '#d81e00', '#5ea702', '#cfae00', '#427ab3', '#89658e', '#00a7aa', '#eeeeec' },
  brights = { '#686a66', '#f54235', '#99e343', '#fdeb61', '#84b0d8', '#bc94b7', '#37e6e8', '#f1f1f0' },
}

config.animation_fps = 1
config.default_cursor_style  = "BlinkingBar"
config.cursor_blink_ease_in  = "Constant"
config.cursor_blink_ease_out = "Constant"

config.line_height = 1


config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 0,
}


return config
