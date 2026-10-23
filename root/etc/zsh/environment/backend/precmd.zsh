# After every command, restore the cursor
# from what the terminal emulator wants.
_fix_cursor() {
   echo -ne '\e[0 q'
}
precmd_functions+=(_fix_cursor)

