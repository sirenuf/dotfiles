# autoexec.zsh
#
# Run automatic startup commands, like initialising directories or files.

# Make git use ~/.config/git/config instead of ~/.gitconfig
if [[ -n "$GIT_CONFIG_GLOBAL" && ! -f "$GIT_CONFIG_GLOBAL" ]]; then
    mkdir -p "${GIT_CONFIG_GLOBAL:h}"
    touch "$GIT_CONFIG_GLOBAL"
fi

