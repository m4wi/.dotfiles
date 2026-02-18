#
# ~/.bashrc
#

# If not running interactively, don't do anything
 [[ $- != *i* ]] && return

## ---- EXPORTS ---- ##
    #export HISTCONTROL=ignoredups:erasedups
    export HISTSIZE=50
    export HISTFILESIZE=100
    #export PROMPT_COMMAND="history -a"
    export TERM=xterm-256color
#    export TERM=st-256color
#    export PS1='$([[ $? -eq 0 ]] && printf "\[\e[38;2;255;255;255m\]󰊠" || printf "\[\e[38;2;255;0;0m\]󰊠")  \[\e[0;1;2;38;5;4m\]\w \[\e[0m\]$(PS1_git_branch)' #export PROMPT_COM

    # Solo si estamos dentro de tmux
    if [[ $TERM == "tmux-256color" || $TERM == "tmux" ]]; then
        export TERM=tmux-256color
        export COLORTERM=truecolor
    fi

    PS1_git_branch() {
        if git rev-parse --is-inside-work-tree &>/dev/null; then
            echo "󰊢 ($(git branch --show-current 2>/dev/null)) "
        fi
    }
    if [[ $(tty) == /dev/tty* ]]; then
        export PS1="\[\e[1;31m\][TTY \l]\[\e[0m\] \u@\h:\w\$ "
    else
        export PS1='$([[ $? -eq 0 ]] && printf "󰊠 " || printf "\[\e[38;2;255;0;0m\]󰊠 \[\e[0m\]")\[\e[0;1;2;38;5;4m\]\w \[\e[0m\]'
   #     $(x11_session_bindkeys)
    fi
    
    # Openbox config path
    OBXDIR="$HOME/.config/wm-scripts"

    # Add openbox scripts to PATH
    export PATH="${PATH}:$OBXDIR"
    
#    export PATH=/home/$USER/.local/share/fnm:$PATH

    export FLYCTL_INSTALL="/home/mawi/.fly"
    export PATH="$FLYCTL_INSTALL/bin:$PATH"
    export EDITOR=nvim
    export VISUAL=nvim
    export DUNST_ICONS="$HOME/.config/dunst/dicons"
    export QT_QPA_PLATFORMTHEME=qt5ct
# ----------------- ##



## ---- AUTOMATIC TOOl SETUP ---- ##

# fnm
FNM_PATH="/home/mawi/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
#    eval "$(fnm env --use-on-cd --shell bash)" > /dev/null 2>&1
#    eval "$(phpenv init -)"

# pyenv init
#export PYENV_ROOT="$HOME/.pyenv"
#command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init - bash)"
## ------------------------------ ##



## ---- ALIASES ---- ##

    alias ls='ls --color=auto -C --group-directories-first'
    alias ll='ls -la'
    alias lf='ls -alF'
    alias la='ls -A'
    alias lt='ls --human-readable --size -1 -S --classify'
    alias lu='du -sh * | sort -h'
    alias lc='find . -type f | wc -l'
    alias ld='ls -d */'

    #alias ll="ls -lh"
    #alias la="ls -lAh"
    #alias lt="ls --tree"
    alias .2="cd ../../"
    alias .3="cd ../../../"
    alias .4="cd ../../../../"

    #alias xjs="pnpm"
    alias vi=nvim
    #alias cl="printf '\x1Bc'"
    alias cat="cat -n "
    #alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    #alias sudo="doas"
    # Pacman snippets
    #alias inx="sudo pacman --noconfirm -S "
    #alias zen="pacman "
    #alias view="nsxiv -s f -g 600x800-50-50"

    alias usb-mount="sudo mount -t auto -o uid=$(id -u),gid=$(id -g),umask=0022 /dev/sda1 /mnt/usb"
    alias usb-umount="sudo umount /mnt/usb"

    ## File managment with prompts
    alias mv='mv -i'
    alias rm='rm -i'
    alias cp='cp -i'
    alias ln='ln -i'
    alias mkdir='mkdir -pv'

    alias thome='tmux attach -t home || tmux new-session -s home'
    ## system / disk info
    alias dusage='du -sh * 2>/dev/null'

    alias tx='mv --target-directory=~/.trash/'

    alias untar='tar -zxvf $1' 
    alias root='sudo -i'

    alias rync-obsidian='rclone sync /home/mawi/syncWorkspace/GoogleDrive gdrive:/ --progress'
    alias sigon='eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ed25519'
    alias sigoff='eval "$(ssh-agent -k)"'
    alias code='code --reuse-window --disable-workspace-trust '
    alias cursor='cursor --reuse-window --disable-workspace-trust '
    alias rew="sudo vpm"

## ----------------- ##



## ---- SHELL OPTIONS ---- ##

    shopt -s histappend
    shopt -s autocd
    shopt -s histappend      # Evita sobrescribir el historial, lo agrega en cada sesión
    shopt -s checkwinsize    # Ajusta la terminal automáticamente cuando cambias de tamaño
    shopt -s cmdhist         # Guarda comandos multilínea como una sola entrada en el historial
    #set -o noclobber         # Evita sobrescribir archivos con `>`
    set -o pipefail          # Detecta errores en tuberías
    #set -o errexit           # Sale si un comando falla (útil en scripts)
    #set -o nounset           # Falla si usas una variable no definida
    set -o vi           # Permite usar atajos de Vim en la línea de comandos.

## ----------------------- ##



## ---- FUNCTIONS ---- ##
    
    fzf-dmenu() {
        # note: xdg-open has a bug with .desktop files, so we cant use that shit
        selected="$(/bin/ls /usr/share/applications | fzf -e)"
        [ -n "$selected" ] || return 1  # Si no selecciona nada, salir

        file="/usr/share/applications/$selected"
        
        cmd=$(sed -n '/^\[Desktop Entry\]/,/^\[/ s/^Exec=//p' "$file" | head -1 | sed 's/%.//g')
    #    cmd=$(sed -n 's/^Exec=//p' "/usr/share/applications/$selected" | tail -1 | sed 's/%.//g')
    #    cmd=$(grep '^Exec=' "/usr/share/applications/$selected" | tail -1 | sed 's/^Exec=//' | sed 's/%.//')

        if [ -n "$cmd" ]; then
        setsid $cmd >/dev/null 2>&1
        else
        echo "Error: command not found"
        fi
    }

    tempupload() {
#      echo $1
      UPLOAD_DATABASE="$HOME/.0x0-uploads"
      uploaded_link=$(curl -F"file=@$1" https://0x0.st)
      echo "$1 - $uploaded_link" | tee -a $UPLOAD_DATABASE

    }

    # cut_pdf() {
    #  gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage="$1" -dLastPage="$2" -sOutputFile=cropped-"$3".pdf "$3"; 
    #}


    # trash() {
    #   mv "$@" "$HOME/.trash"
    # }

#    l4d2_silence() {
#        find $1 -type f -name "*.wav" | while read -r file; do
#        dir=$(dirname "$file")            # Obtiene el directorio del archivo
#        name=$(basename "$file")          # Obtiene el nombre sin ruta
#        temp_file="$dir/temp_$name"       # Construye la ruta temporal correctamente

#       duration=$(ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0")
#        ffmpeg -y -i "$file" -filter_complex "aevalsrc=0:d=$duration" -acodec pcm_s16le -ar 44100 -ac 2 "$temp_file" && mv "$temp_file" "$file"
#        done
#    }

#    dnow() {
#        dunstify "BAT: $(cat /sys/class/power_supply/*/capacity)%" "DATE: $(date +'%A %d %B %H:%M -  day : %j')"
#    }

#    PS1_git_branch() {
#        if git rev-parse --is-inside-work-tree &>/dev/null; then
#            echo "󰊢 ($(git branch --show-current 2>/dev/null)) "
#        fi
#    }



## ------------------- ##



## ---- BINDKEYS ---- ##

    bind -r "\e<"
    bind '"\e<\C-a":"fzf-drun\n"'               # aplication launcher
    bind '"\e<\C-p":"fzf-power\n"'               # power managment
    bind 'set show-mode-in-prompt on'
    bind 'set vi-ins-mode-string "   "'
    bind 'set vi-cmd-mode-string "   "'

## ------------------ ##

# fnm
FNM_PATH="/home/mawi/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

