# Always assume the linux tty supports 16 colours.
if [[ $TERM == "linux" ]]; then
  export TERM="linux-16color"
fi

# Make git put the config in .config instead.
mkdir -p $XDG_CONFIG_HOME/git && touch $XDG_CONFIG_HOME/git/config


autoload -U compinit                                      # Declare function compinit
autoload -Uz vcs_info                                     # Enables version-control info in prompt

setopt interactive_comments                               # Allow comments inside the prompt 
setopt prompt_subst                                       # So vcs_info can get re-eval'd in my prompt

eval "$(dircolors -b)"                                    # Sets proper LS_COLORS env, so programs have proper colour support. 

# Makes sudo only use real auto completes
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}     # Auto complete with proper $LS_COLORS
zstyle ':completion:*' menu select                        # Highlighted menu on tab completion

# vcs
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' 󰊢 %F{13}%b%f'

# compinit setup
compinit -d $ZSH_CACHE_DIR/zcompdump                      # Allows subcommands completion for e.g. git or ssh.
_comp_options+=(globdots)                                 # Include hidden files in auto completion.


# Blocks zsh prompt setting changes.
# Leave this at the end always before any stty changes.
ttyctl -f
