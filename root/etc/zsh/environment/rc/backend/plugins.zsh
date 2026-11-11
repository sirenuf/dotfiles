# plugins.zsh
#
# Plugins should be handled by the distributions package manager preferrably.
#
# Recursively scan /usr/share/zsh for plugins. Plugins are usually packaged differently
# but share the same filename which ZSH source's to load them.

# anonymous to prevent leaking.
() { 
local file plugin
local search_paths=(
    "/usr/share"
    "/opt/homebrew/share"
)

local plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# (N) hides 'no matches found' error.
local files=(
    $search_paths[1]/zsh*/**/*.zsh(N)
    $search_paths[2]/zsh*/**/*.zsh(N)
)

# Search for every plugin recursively.
for plugin in $plugins; do
  for file in $files; do

    # t removes absolute path
    # r removes file extension
    if [[ $plugin == $file:t:r ]]
    then
      source $file
    fi

  done
done

}
