if status is-interactive
    if status is-login
        if not set -q DAVIS_DM_LAUNCHED
            if not set -q SSH_CONNECTION; and not set -q SSH_CLIENT; and not set -q SSH_TTY
                if not set -q DISPLAY; and not set -q WAYLAND_DISPLAY
                    set -l tty_path (tty 2>/dev/null)
                    if test "$tty_path" = "/dev/tty3"
                        if command -sq ly
                            echo "tty3 detected, launching ly..."
                            set -gx DAVIS_DM_LAUNCHED 1
                            exec ly
                        end

                        if command -sq gdm
                            echo "tty3 detected, but gdm is managed by systemd and cannot be launched reliably from fish." >&2
                            echo "Install ly for tty3 auto-login-manager behavior, or enable gdm as your system display manager." >&2
                        end
                    end
                end
            end
        end
    end
end
