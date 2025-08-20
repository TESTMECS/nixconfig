local wezterm = require("wezterm")
local act = require("wezterm").action
local config = wezterm.config_builder()
config.color_scheme = "Wez"
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = {
	-- Copy mode
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	-- Split panes
	{ key = "-", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Pane navigation (h/j/k/l)
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	-- Resize panes
	{ key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
	-- Tabs
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "Tab", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter name for new workspace",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
}
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"ZedMono Nerd Font Mono",
	"Isoveka Nerd Font",
})
config.default_domain = "WSL:NixOS"
config.front_end = "WebGpu"
return config
