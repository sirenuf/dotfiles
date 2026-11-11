# common.zsh
# 
# Setup different backend options in the shell.

# the "linux" tty has a broken terminfo and doesn't advertise ansi 16 colour support
# even if the framebuffer renders ansi colours just fine.
# if you force this to linux-16color it makes programs use the right terminfo actually
# compatible with the framebuffer.
[[ $TERM == "linux" ]] && export TERM="linux-16color"

autoload -U compinit                                      # Declare function compinit
autoload -Uz vcs_info                                     # Enables version-control info in prompt

setopt interactive_comments                               # Allow comments inside the prompt 
setopt prompt_subst                                       # So vcs_info can get re-eval'd in my prompt

if [[ $(uname -s) != "Darwin" ]]; then
    eval "$(dircolors -b)"                                # Sets proper LS_COLORS env, so programs have proper colour support. 
else
    export LS_COLORS="$(vivid generate ansi)"
fi

# Makes sudo only use real auto completes
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}     # Auto complete with proper $LS_COLORS
zstyle ':completion:*' menu select                        # Highlighted menu on tab completion

# vcs
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{13} %b%f'

# compinit setup
compinit -d $ZSH_CACHE_DIR/zcompdump                      # Allows subcommands completion for e.g. git or ssh.
_comp_options+=(globdots)                                 # Include hidden files in auto completion.


# Blocks zsh prompt setting changes.
# Leave this at the end always before any stty changes.
ttyctl -f
