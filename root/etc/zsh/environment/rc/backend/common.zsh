# Makes sudo only use real auto completes
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

autoload -U compinit                    # Declare function compinit
zstyle ':completion:*' menu select      # Highlighted menu on tab completion
compinit -d $ZSH_CACHE_DIR/zcompdump    # Allows subcommands completion for e.g. git or ssh.
_comp_options+=(globdots)               # Include hidden files in auto completion.

# Use comments in your zsh prompt
setopt interactive_comments

# Sets proper LS_COLORS env, so programs have proper colour support automatically.
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Always assume the linux tty supports 16 colours.
if [[ $TERM == "linux" ]]; then
  export TERM="linux-16color"
fi

# Make git put the config in .config instead.
mkdir -p $XDG_CONFIG_HOME/git && touch $XDG_CONFIG_HOME/git/config

# Blocks zsh prompt setting changes.
# Leave this at the end always before any stty changes.
ttyctl -f
