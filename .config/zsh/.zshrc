# Kphoen ohmyzsh recreation
PROMPT="[%F{red}%n%f@%F{magenta}%m%f:%F{063}%~%f]"$'\n'"%# "

# Load source
source "$HOME/.config/zsh/.alias"

# Load colours
autoload -U colors && colors

# Ctrl + D short cut and other bindkeys
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M emacs '^[[3^' kill-word # seems specific to urvxt

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
# Arrow keys
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


# History in custom cache folder
HISTSIZE=2000
SAVEHIST=2000
HISTFILE=~/.cache/zsh/history

# Auto completes
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Load plugins
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.config/zsh/plugins/zsh-window-title/zsh-window-title.zsh
