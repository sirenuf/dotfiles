# Fix cache
mkdir -p ~/.cache/.zsh
touch ~/.cache/.zsh/.history

# Fix beam cursor (Vim)
_fix_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

# Prompt
PROMPT="%B[%b%F{yellow}%n%f@%F{blue}%m%f %B%F{white}%~%f]%b"$'\n'"> "
#PROMPT="[%F{blue}%m%f %~]"$'\n'"%F{yellow}%n%f > "

# Load alias
source "$ZDOTDIR/aliases"

# Locale shit
export LANG="en_US.UTF-8"
export LC_COLLATE="C"
export LC_CTYPE="sv_SE.UTF-8"
export LC_TIME="sv_SE.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"

# History in custom cache folder
HISTSIZE=2000
SAVEHIST=2000
HISTFILE=~/.cache/.zsh/.history

# Binds
source "$ZDOTDIR/keybinds"

# Path
source "$ZDOTDIR/path"

# Programs
export EDITOR="lvim"

# Colour stuff
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

#nable touch features in Firefox
export MOZ_USE_XINPUT2=1

# Theming
export GTK_THEME="Adwaita:dark"
export GTK2_RC_FILES="/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc"
export QT_STYLE_OVERRIDE="Adwaita-Dark"

# Global menu support
export GTK_MODULES="unity-gtk-module"
export SAL_USE_VCLPLUGIN=gtk

# Load plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

sleep .2
reset
clear
fortune
