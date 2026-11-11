typeset -U path
path+=(
  /sbin # make sure sbin is in path or else syntax highlighting breaks. It is expected for sudo.
  $DOTNET_CLI_HOME/.dotnet/tools
  ~/.local/bin
)

# Darwin-reserved code.
if [[ "$(uname -s)" == "Darwin" ]]; then
    if [ -x "/usr/libexec/path_helper" ]; then
	eval `/usr/libexec/path_helper -s`
    fi

    if [ -x "/opt/homebrew/bin/brew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi
