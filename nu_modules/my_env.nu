export-env {
    let-env BAT_THEME = "Dracula"
    let-env LS_COLORS = (vivid generate dracula | str trim)
    let-env SHELL = "nu"
}
