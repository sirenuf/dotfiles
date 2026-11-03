# terminal.zsh
# Ghostty's auto zsh integration does not work
# because of my unusual way of defining the $ZDOTDIR.
#
# To solve this, simply just manually source the integration.
# It does the exact same thing.

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi
