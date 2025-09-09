# Dotfiles


## 🏗️ Creación inicial del repositorio bare

En tu máquina principal (donde configurarás todo por primera vez):

1. **Crear el repositorio bare en tu `$HOME`:**

```bash
# Inicialización del repo en modo bare
git init --bare $HOME/.dotfiles

# Alias para ayudar el manejar el repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Quitar el texto de untracked files
dotfiles config --local status.showUntrackedFiles no

# preferencia ramas dev main 
dotfiles branch -m main
```


## 🏗️ Instalación del repositorio

En tu máquina secundaria o replica:

1. **Crear el repositorio bare en tu `$HOME`:**

```bash
# el repo se clonara en tu home reemplazando todos los archivos
git clone --bare git@github.com:USUARIO/dotfiles.git $HOME/.dotfiles

```
2. **En caso de haber problemas con algunos archivos repetidos:**
```bash
mkdir -p $HOME/.config/dotfiles/backups
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .dotfiles-backup/{}
dotfiles checkout

```

2. **En caso de usar svn para archivos específicos:**

```bash

svn export https://github.com/USUARIO/dotfiles/trunk/.vimrc
curl -o ~/.vimrc https://raw.githubusercontent.com/USUARIO/dotfiles/main/.vimrc
wget -O ~/.vimrc https://raw.githubusercontent.com/USUARIO/dotfiles/main/.vimrc

```

## 🏗️ Uso del repositorio

```bash
# Ver estado
dotfiles status

# Agregar un archivo
dotfiles add .zshrc

# Hacer commit
dotfiles commit -m "Add zshrc"

# Subir cambios
dotfiles push

# Traer cambios de otra máquina
dotfiles pull
```