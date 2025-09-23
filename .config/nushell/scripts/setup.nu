export def install-all [] {
    touch ~/.zoxide.nu
    mkdir ~/.local/share/atuin
    touch ~/.local/share/atuin/init.nu
    # rust
    print "installing rust"
    install-rust
    # neovim
    print "installing neovim"
    install-neovim
    print "install some packages"
    install-packages
    # some rust binaries: zellij, rg, delta, difftastic, vivid, bat
    print "installing useful rust binaries"
    $env.PATH = ($env.PATH | append ~/.cargo/bin/)
    install-tools
    print "setting up nushell modules"
    mkdir ~/.config/nushell/scripts/
    cp ../nushell/config.nu ~/.config/nushell/config.nu
    cp * ~/.config/nushell/scripts/

    print "install win32 yank"
    install-win32yank
}

export def install-rust [] {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

export def install-neovim [] {
    cd /tmp
    let kernel_name = uname | get kernel-name | str downcase
    let machine = uname | get machine
    let os_name = if $kernel_name == "linux" {
        "linux-x86_64"
    } else {
        "macos-arm64"
    }
    let base = $"nvim-($os_name)"
    let f = $"($base).tar.gz"
    print "downloading nvim..."
    http get $"https://github.com/neovim/neovim/releases/download/nightly/($f)" o> $f
    print "download complete"
    tar -xzf $f
    let folder_name = if $kernel_name == "linux" {
        "nvim-linux64"
    } else {
        "nvim-macos"
    }
    let target_folder = $"~/($folder_name)" | path expand
    rm -rf $target_folder
    mv $base $target_folder

    print "cleaning..."
    rm $f
    if (not ('/usr/local/bin/nvim' | path exists)) {
        sudo ln -s /home/windsoilder/nvim-linux64/bin/nvim /usr/local/bin/nvim
    }
}

export def install-tools [] {
    for bin in ["zellij", "ripgrep", "difftastic", "vivid", "bat", "git-delta", "starship", "exa", "atuin"] {
        print $"install ($bin)"
        cargo install $bin
    }
    print "install uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    zoxide init nushell | save -f ~/.zoxide.nu
}

export def install-packages [] {
    sudo zypper install -y git
    sudo zypper install -y gcc
    sudo zypper install -y htop
    sudo zypper install -y make
    sudo zypper install -y gcc-c++
    sudo zypper install -y clang
    sudo zypper install -y gh
    sudo zypper install -y fish
    sudo zypper install -y mold
    zypper ar --gpgcheck-allow-unsigned -f https://yum.fury.io/rsteube/ carapace
    zypper install -y carapace-bin
}

export def install-win32yank [] {
    cd /tmp
    wget https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
    unzip /tmp/win32yank.zip
    chmod +x /tmp/win32yank.exe
    sudo mv /tmp/win32yank.exe /usr/local/bin/
    rm win32yank.zip
}
