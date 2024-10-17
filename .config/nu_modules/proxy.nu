export def --env enable-proxy [] {
    let host_ip = (cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
    $env.https_proxy = $"http://($host_ip):10809"
    $env.http_proxy = $"http://($host_ip):10809"
}

export def --env disable-proxy [] {
    hide-env https_proxy
    hide-env http_proxy
}
