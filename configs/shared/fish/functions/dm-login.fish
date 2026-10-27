function dm-login --description "Start a display manager from a TTY login shell"
    set -l target ly
    if test (count $argv) -ge 1
        set target $argv[1]
    end

    if not status is-interactive
        echo "dm-login must run in an interactive fish shell." >&2
        return 1
    end

    set -l tty_path (tty 2>/dev/null)
    if test -z "$tty_path"
        echo "dm-login must run on a real TTY." >&2
        return 1
    end

    switch $target
        case ly
            if command -sq ly
                set -gx DAVIS_DM_LAUNCHED 1
                exec ly
            end
            echo "ly is not installed." >&2
            echo "Install it with: sudo pacman -S ly" >&2
            return 1
        case gdm
            if command -sq gdm
                echo "gdm is service-managed and should not be started directly from a user fish shell." >&2
                echo "Use systemd instead, for example: sudo systemctl start gdm" >&2
                return 1
            end
            echo "gdm is not installed." >&2
            return 1
        case '*'
            echo "Usage: dm-login [ly|gdm]" >&2
            return 1
    end
end
