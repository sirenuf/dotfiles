# Set zsh in "emacs mode", like bash
# instead of $EDITOR dependent.
bindkey -e

# Ctrl+Backspace has no terminfo name. Konsole usually sends ^H.
bindkey '^H' backward-kill-word

# Do nothing on PG UP/DOWN.
# I don't like the history searching it does.
function _do_nothing() {}

function bindkey_all() {
  local widget=$1 sequence
  shift

  for sequence in "$@"; do
    [[ -n $sequence ]] && bindkey -- "$sequence" $widget
  done
}

#           widget                 terminfo             fallbacks
bindkey_all beginning-of-line     "${terminfo[khome]}" $'\e[H' $'\eOH' $'\e[1~' $'\e[7~'
bindkey_all end-of-line           "${terminfo[kend]}"  $'\e[F' $'\eOF' $'\e[4~' $'\e[8~'
bindkey_all delete-char           "${terminfo[kdch1]}" $'\e[3~'
bindkey_all _do_nothing           "${terminfo[kpp]}"   $'\e[5~'
bindkey_all _do_nothing           "${terminfo[knp]}"   $'\e[6~'
bindkey_all reverse-menu-complete "${terminfo[kcbt]}"  $'\e[Z'
bindkey_all backward-word         "${terminfo[kLFT5]}" $'\e[1;5D' $'\e[5D' $'\eOd'
bindkey_all forward-word          "${terminfo[kRIT5]}" $'\e[1;5C' $'\e[5C' $'\eOc'
bindkey_all kill-word             "${terminfo[kDC5]}"  $'\e[3;5~' $'\e[3^'

zle -N _do_nothing

unfunction bindkey_all
