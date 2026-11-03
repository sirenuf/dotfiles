typeset -U path
path+=(
  /sbin # make sure sbin is in path or else syntax highlighting breaks. It is expected for sudo.
  $DOTNET_CLI_HOME/.dotnet/tools
  ~/.local/bin
)
