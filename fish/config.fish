set PATH /Users/chenhongze/.cargo/bin $PATH

set LANG "zh_CN.UTF-8"
set LC_ALL "zh_CN.UTF-8"
set -g -x HORS_ENGINE bing

set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
set -gx LDFLAGS "-L/usr/local/opt/openssl@1.1/lib"
set -gx CPPFLAGS "-I/usr/local/opt/openssl@1.1/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/openssl@1.1/lib/pkgconfig"


alias emacs="/usr/local/cellar/emacs/27.1/bin/emacs"
alias emacsr="/usr/local/cellar/emacs/27.1/bin/emacs -q --load ~/.emacs.d/emacs-rust-config/standalone.el"