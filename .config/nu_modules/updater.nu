def update-all [] {
    print "============= updating nu ================="
    update-nu
    print "============= updating neovim ================="
    update-nvim
}

def update-nu [] {
    print "fetching downloading link"
    let kernel_name = uname | get kernel-name | str downcase
    let machine = uname | get machine
    let os_name = if $kernel_name == "linux" {
        "unknown-linux-gnu"
    } else {
        # it's macos
        "apple-darwin"
    }
    let link = http get https://api.github.com/repos/nushell/nightly/releases
        | sort-by -r published_at
        | select tag_name name published_at assets_url assets
        | get 0
        | get assets.browser_download_url
        | filter { $in =~ $"($machine)-($os_name)" }
        | get 0
    cd /tmp
    print $"downloading from ($link)"
    http get $link | save -fp nu.tar.gz
    tar -xzf nu.tar.gz
    let nu_dir = ls nu-* | get name.0
    let target_dir = which nu | get path | path dirname | get 0
    print $"copying to ($target_dir)"
    let nu_with_plugins = ($nu_dir | path join "nu") + "*"
    mv ($nu_with_plugins | into glob) $target_dir

    cd $target_dir
    for nu_plugin in (ls nu_plugin_* | get name) {
        plugin add $nu_plugin
    }

    print "cleaning..."
    rm -rf nu.tar.gz
    rm -rf nu-*
}

def update-nvim [] {
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
