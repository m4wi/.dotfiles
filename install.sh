#!/usr/bin/env sh


SKIP_BACKUP=1
SKIP_SAME=y
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


bklink() {
    local file_name=$1
    local fileout=$2 
    local filein="$DOTFILES_DIR/$file_name"


    if [ -e "$fileout" ] || [ -L "$fileout" ]; then
        if [ "$SKIP_SAME" = "y" ]; then
		return
	fi
	echo "Moviendo archivo existente $fileout a $fileout.bk"
        mv "$fileout" "$fileout.bk"
    fi

    echo "Creando link: $fileout -> $filein"
    ln -s "$filein" "$fileout"
}


# Install .bashrc
bklink .bashrc $HOME/.bashrc

bklink .xinitrc $HOME/.xinitrc

bklink .nanorc $HOME/.nanorc

bklink .config/nvim $HOME/.config/nvim

bklink .config/fontconfig $HOME/.config/fontconfig
