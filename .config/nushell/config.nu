# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
$env.PATH = ($env.PATH | append ~/.cargo/bin/ | append ~/.local/bin/)
$env.LS_COLORS = (vivid generate nord)
$env.config.shell_integration.osc8 = false
$env.EDITOR = "nvim"

source ~/.zoxide.nu
source ~/.local/share/atuin/init.nu

alias lt = exa --tree --level=2 --long --icons --git
alias zl = zellij ls
alias za = zellij attach
alias zs = zellij -n compact -s
alias gs = git switch
alias gr = git restore

# cargo relative alias
alias ct = cargo test
alias cb = cargo build
alias ci = cargo install --path .
alias cbr = cargo build --release

use vac_general.nu [vl, vp]
use git-helper.nu *
use updater.nu *
use job-util.nu [fgr tgl]

export def lg [] {
    ls | sort-by type | grid -c -i
}

export def --env proxy [] {
    let new_env = {
        http_proxy: "socks5://127.0.0.1:8889"
        https_proxy: "socks5://127.0.0.1:8889"
    }
    load-env $new_env
}

export def --env noproxy [] {
    hide-env http_proxy
    hide-env https_proxy
}

export def sync [--pull] {
    gh repo sync WindSoilder/nushell --source nushell/nushell
    gh repo sync WindSoilder/reedline --source nushell/reedline
    gh repo sync WindSoilder/nu_scripts --source nushell/nu_scripts
    gh repo sync WindSoilder/zed --source zed-industries/zed

    if $pull {
        cd /Users/chenhongze/projects/rust_online_code/nushell
        git fetch
        cd /Users/chenhongze/projects/rust_online_code/reedline
        git fetch
        cd /Users/chenhongze/projects/rust_online_code/zed
        git fetch
    }
}

# setup external completer
let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}
let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}
# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config.completions = {
    external: {
        enable: true
        completer: $external_completer
    }
}

$env.config.keybindings ++= [{
    name: insert_new_line
    modifier: control
    keycode: char_j
    mode: emacs
    event: { edit: InsertString, value: "\n"}
}]
