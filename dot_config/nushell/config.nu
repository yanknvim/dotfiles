$env.config.show_banner = false

$env.config.keybindings ++= [{
    name: history_find
    modifier: control
    keycode: char_p
    mode: [emacs, vi_normal, vi_insert]
    event: [
        {
            send: executehostcommand,
            cmd: "commandline edit -r (history | get command | str join (char newline) | fzf)"
        }
    ]
}
{
    name: reload
    modifier: none,
    keycode: f5,
    mode: [emacs, vi_normal, vi_insert],
    event: {
        send: executehostcommand
        cmd: "exec nu"
    }
}]

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
