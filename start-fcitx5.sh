#!/bin/bash
# fcitx5 唯一启动入口 — 只从 ~/dwm/autostart.sh 调用，不要在别处再启动 fcitx5。

export DISPLAY="${DISPLAY:-:0}"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export SDL_IM_MODULE=fcitx

ensure_profile() {
    local profile="$HOME/.config/fcitx5/profile"
    [ -f "$profile" ] || return 0
    if ! rg -q '^Layout=colemak$' "$profile" 2>/dev/null; then
        sed -i 's/^Layout=$/Layout=colemak/' "$profile"
    fi
}

apply_keyboard() {
    /home/sky/scripts/setxmodmap-colemak.sh
}

start_fcitx() {
    for _ in $(seq 1 60); do
        xdpyinfo >/dev/null 2>&1 && break
        sleep 1
    done

    ensure_profile
    if ! pgrep -x fcitx5 >/dev/null; then
        fcitx5 -d --replace
        sleep 0.5
    fi
    apply_keyboard
}

case "${1:-}" in
    --check)
        start_fcitx
        ;;
    *)
        start_fcitx
        ;;
esac
