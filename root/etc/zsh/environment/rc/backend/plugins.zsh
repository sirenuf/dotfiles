() { # anonymous to prevent leaking.

local file plugin
local search_path=/usr/share

local plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# (N) hides 'no matches found' error.
local files=($search_path/zsh*/**/*.zsh(N))

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
