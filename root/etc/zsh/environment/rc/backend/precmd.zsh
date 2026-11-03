# After every command, restore the cursor
# from what the terminal emulator wants.
_fix_cursor() {
   echo -ne '\e[0 q'
}

# If the zsh cache dir don't exist,
# then do not write history on logout.
_skip_history_writing() {
  [[ -d $ZSH_CACHE_DIR ]] || unset HISTFILE
}
exit logout() { _skip_history_writing; builtin $0 "$@" }

precmd_functions+=(
  _fix_cursor
)
