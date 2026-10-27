if status is-interactive
    # Commands to run in interactive sessions can go here

    # Enable starship
    starship init fish | source
    vfox activate fish | source
    zoxide init fish | source
    aigate-cli init fish | source
end

# Set cursor theme for niri compositor
set -gx XCURSOR_THEME "Bibata-Modern-Ice"
set -gx XCURSOR_SIZE "24"

# Add scripts directory to PATH
fish_add_path $HOME/.config/scripts

# Set Chrome executable for Flutter web development
set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable

alias vi nvim
alias vim nvim
alias zed zeditor
alias tree "eza -T"

alias pctl powerprofilesctl

alias codem "HOME=$HOME/.codex_xinta codex"
alias codey "HOME=$HOME/.codex_xuanzhi codex"


# Configure sudo askpass helper
set -gx SUDO_ASKPASS $HOME/.askpass.sh
set -gx DOCKER_BUILDKIT 1


# pnpm
set -gx PNPM_HOME "/home/davisye/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
set -x RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
set -x RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup

# Proxy for terminal apps (sing-box on 127.0.0.1:7897)
set -gx http_proxy http://127.0.0.1:7897
set -gx https_proxy http://127.0.0.1:7897
set -gx all_proxy socks5h://127.0.0.1:7897
set -gx no_proxy "localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8"
set -x RUSTUP_DIST_SERVER https://static.rust-lang.org
set -x RUSTUP_UPDATE_ROOT https://static.rust-lang.org/rustup
