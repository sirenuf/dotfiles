# Makes sudo only use real auto completes
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

autoload -U compinit                    # Declare function compinit
zstyle ':completion:*' menu select      # Highlighted menu on tab completion
compinit -d $ZSH_CACHE_DIR/zcompdump    # Allows subcommands completion for e.g. git or ssh.
_comp_options+=(globdots)               # Include hidden files in auto completion.

setopt interactive_comments

# Sets proper LS_COLORS env, so programs have proper colour support automatically.
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Always assume the tty supports 16 colours.
if [[ $TERM == "linux" ]]; then
  export TERM="linux-16color"
fi
