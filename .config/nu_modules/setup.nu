export def install-all [] {
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
}

export def install-rust [] {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

export def install-neovim [] {
    cd /tmp
    let kernel_name = uname | get kernel-name | str downcase
    let machine = uname | get machine
    let os_name = if $kernel_name == "linux" {
        "linux64"
    } else {
        "macos-x86_64"
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
}

export def install-tools [] {
    for bin in ["zellij", "ripgrep", "difftastic", "vivid", "bat", "git-delta", "starship", "exa"] {
        print $"install ($bin)"
        cargo install $bin
    }
    print "install uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
}

export def install-packages [] {
    sudo zypper install git -y
    sudo zypper install gcc -y
    sudo zypper install htop -y
    sudo zypper install make -y
    sudo zypper install gcc-c++ -y
    sudo zypper install clang -y
    sudo zypper install gh -y
    sudo zypper install fish -y
    zypper ar --gpgcheck-allow-unsigned -f https://yum.fury.io/rsteube/ carapace
    zypper install carapace-bin
}
