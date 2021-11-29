local wezterm = require 'wezterm';

return {
    -- ime
    use_ime = true,

    -- font
    font = wezterm.font_with_fallback({
        "Noto Sans Mono", "Noto Sans Mono CJK SC"
    }),
    font_size = 11,

    -- tabbar
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,

    -- color scheme
    color_scheme = "Dracula",

    -- zsh and bindkey
    default_prog = {"/usr/bin/zsh"},
    exit_behavior = "Close",
    keys = {
        {
            key = "LeftArrow",
            mods = "ALT",
            action = wezterm.action {SendString = "\x1b\x62"}
        }, {
            key = "RightArrow",
            mods = "ALT",
            action = wezterm.action {SendString = "\x1b\x66"}
        }, {
            key = "LeftArrow",
            mods = "CTRL",
            action = wezterm.action {SendString = "\x1b\x62"}
        }, {
            key = "RightArrow",
            mods = "CTRL",
            action = wezterm.action {SendString = "\x1b\x66"}
        }
    },
    mouse_bindings = {
        -- Ctrl-RightClick will open the link under the mouse cursor
        {
            event = {Up = {streak = 1, button = "Right"}},
            mods = "CTRL",
            action = "OpenLinkAtMouseCursor"
        }
    }
}
