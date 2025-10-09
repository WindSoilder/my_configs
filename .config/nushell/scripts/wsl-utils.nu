export def cp-to-desk [file_path: path] {
    let windows_user = do { cmd.exe /c "echo %USERNAME%" } | complete | get stdout | str trim
    let desktop_path = $"/mnt/c/Users/($windows_user)/Desktop"
    cp $file_path $desktop_path
}
