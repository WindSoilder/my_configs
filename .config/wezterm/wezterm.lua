local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
    -- window:gui_window():maximize()
  end)

return {
  font = wezterm.font 'Berkeley Mono Variable',
  font_size = 19,
  native_macos_fullscreen_mode = true,
  color_scheme = "Dracula",
  hide_tab_bar_if_only_one_tab = true,
  key = "LeftBracket", mods = "ALT", action = wezterm.action{SendString="\x1b["},
  key = "RightBracket", mods = "ALT", action = wezterm.action{SendString="\x1b]"}
}
