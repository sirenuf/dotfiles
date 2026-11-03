alias_if_exists   ip      "--color=auto"
alias_if_exists   cat     "-Pp"                   batcat bat
alias_if_exists   ls      "--group --icons auto"  eza
alias_if_exists   ffetch  ""                      fastfetch
alias_if_exists   open    ""                      xdg-open
alias_if_exists   rm      "-i"
alias_if_exists   ffmpeg  "-hide_banner"
alias_if_exists   ffprobe "-hide_banner"
alias_if_exists   ffplay  "-hide_banner"


touch $ZSH_ALIASES_CACHED_FILE

# If a command was not found, add
# a break line so it is fancy
if [[ $warning_printed == true ]]
then
  print -u2 ""
fi

unset warning_printed
unfunction command_exists
unfunction alias_if_exists
