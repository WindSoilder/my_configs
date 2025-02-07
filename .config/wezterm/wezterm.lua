local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
	-- window:gui_window():maximize()
end)

return {
	font = wezterm.font("0xProto Nerd Font"),
	font_size = 14,
	native_macos_fullscreen_mode = true,
	-- color_scheme = "Gruvbox dark, hard (base16)",
	color_scheme = "Nord (base16)",
	hide_tab_bar_if_only_one_tab = true,
	front_end = "WebGpu",
	keys = {
		{ key = "LeftBracket", mods = "ALT", action = wezterm.action({ SendString = "\x1b[" }) },
		{ key = "RightBracket", mods = "ALT", action = wezterm.action({ SendString = "\x1b]" }) },
		{
			key = "d",
			mods = "CMD",
			action = wezterm.action.SplitPane({
				direction = "Right",
				size = { Percent = 50 },
			}),
		},
		{
			key = "D",
			mods = "CMD",
			action = wezterm.action.SplitPane({
				direction = "Down",
				size = { Percent = 50 },
			}),
		},
		{
			key = "Enter",
			mods = "CMD|SHIFT",
			action = wezterm.action.TogglePaneZoomState,
		},
	},
}
