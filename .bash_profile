#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Enviroment variables
export NO_AT_BRIDGE=1


# Puedes definir la sesión deseada aquí (x11 o wayland)
#export WM_SESSION="wayland"
export WM_SESSION="other"

OBXDIR="$HOME/.config/wm-scripts"

# Add openbox scripts to PATH
export PATH="${PATH}:$OBXDIR"


# Solo ejecuta en TTY1 y si no estás en una sesión gráfica
if [ "${XDG_VTNR}" -eq 1 ] && [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ]; then
    case "$WM_SESSION" in
        x11)
            if ! command -v startx >/dev/null 2>&1; then
                echo "startx command not found" >&2
                exit 1
            fi
            export XDG_SESSION_TYPE=x11
            export GDK_BACKEND=x11
            exec startx >/dev/null 2>&1
            ;;
        wayland)
            # echo "holasss"
            export XDG_SESSION_TYPE=wayland
            export WLR_BACKENDS=drm
            export MOZ_ENABLE_WAYLAND=1
            export QT_QPA_PLATFORM=wayland
            export SDL_VIDEODRIVER=wayland
            export CLUTTER_BACKEND=wayland
            export LIBSEAT_BACKEND=seatd
            exec sway
#
            ;;
        *)
            echo "WM_SESSION no está definido correctamente (usa 'x11' o 'wayland')." >&2
            ;;
  esac
fi
