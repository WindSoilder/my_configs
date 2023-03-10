def read_system_theme [] {
    # Replace with Get-ItemProperty or gsettings, as necessary
    do -i { defaults read -globalDomain AppleInterfaceStyle } | str trim
}

# Only works on macOS!!
export def-env auto_load_theme [] {
    let theme = (read_system_theme);
    if $theme == "Dark" {
        dt
    } else {
        lt
    }
}

def-env lt [] {
    let-env BAT_THEME = "gruvbox-light"
    let-env LS_COLORS = (vivid generate ~/.config/vivid/gruvbox-light.yml)

    use ./themes/gruvbox_light_theme.nu *
    let-env config = ($env.config | merge {color_config: (gruvbox_light-medium)})

    cp ~/.config/wezterm/wezterm_light.lua ~/.config/wezterm/wezterm.lua
    cp ~/.config/zellij/config_light.kdl ~/.config/zellij/config.kdl
}

def-env dt [] {
    let-env BAT_THEME = "Dracula"
    let-env LS_COLORS = (vivid generate ~/.config/vivid/dracula.yml)

    use ./themes/dracula_theme.nu *
    let-env config = ($env.config | merge {color_config: (dracula)})

    cp ~/.config/wezterm/wezterm_dark.lua ~/.config/wezterm/wezterm.lua
    cp ~/.config/zellij/config_dark.kdl ~/.config/zellij/config.kdl
}
