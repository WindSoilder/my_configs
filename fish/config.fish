set LANG "zh_CN.UTF-8"
set LC_ALL "zh_CN.UTF-8"
set -g -x HORS_ENGINE bing

# functions for changing themes
function light
    cp ~/.config/alacritty/alacritty_solarized_light.yml ~/.config/alacritty/alacritty.yml
    cp ~/.config/helix/config_light.toml ~/.config/helix/config.toml
    set -g -x BAT_THEME 'Solarized (light)'
end

function night
    cp ~/.config/alacritty/alacritty_solarized_dark.yml ~/.config/alacritty/alacritty.yml
    cp ~/.config/helix/config_dark.toml ~/.config/helix/config.toml
    set -g -x BAT_THEME 'Solarized'
end

function nord
    cp ~/.config/alacritty/alacritty_nord.yml ~/.config/alacritty/alacritty.yml
    cp ~/.config/helix/config_nord.toml ~/.config/helix/config.toml
    set -g -x BAT_THEME 'Nord'
end

function pro
    cp ~/.config/alacritty/alacritty-monokai-pro.yml ~/.config/alacritty/alacritty.yml
    cp ~/.config/helix/config_monokai_pro.toml ~/.config/helix/config.toml
    set -g -x BAT_THEME 'Nord'
end

function mac
    cp ~/.config/alacritty/alacritty-monokai-pro-machine.yml ~/.config/alacritty/alacritty.yml
    cp ~/.config/helix/config_monokai_pro_machine.toml ~/.config/helix/config.toml
    set -g -x BAT_THEME 'Nord'
end

function oct
    cp ~/.config/alacritty/alacritty-monokai-pro-octagon.yml ~/.config/alacritty/alacritty.yml
    cp ~/.config/helix/config_monokai_pro_octagon.toml ~/.config/helix/config.toml
    set -g -x BAT_THEME 'Nord'
end

function ris
    cp ~/.config/alacritty/alacritty-monokai-pro-ristretto.yml ~/.config/alacritty/alacritty.yml
    cp ~/.config/helix/config_monokai_pro_ristretto.toml ~/.config/helix/config.toml
    set -g -x BAT_THEME 'Nord'
end

function spe
    cp ~/.config/alacritty/alacritty-monokai-pro-spectrum.yml ~/.config/alacritty/alacritty.yml
    cp ~/.config/helix/config_monokai_pro_spectrum.toml ~/.config/helix/config.toml
    set -g -x BAT_THEME 'Nord'
end

set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
set -gx LDFLAGS "-L/usr/local/opt/openssl@1.1/lib"
set -gx CPPFLAGS "-I/usr/local/opt/openssl@1.1/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/openssl@1.1/lib/pkgconfig"


alias es="/usr/local/cellar/emacs/27.1/bin/emacs"
alias esr="/usr/local/cellar/emacs/27.1/bin/emacs -q --load /Users/chenhongze/.emacs.d/emacs-rust-config/standalone.el"
