# Use normal (bash-like) editing, no matter what $EDITOR is.
# Without this, zsh switches to vi-style if $EDITOR contains "vi".
bindkey -e

# Look up what this terminal sends for each key (see: man 5 terminfo).
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Delete]="${terminfo[kdch1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"
key[Control-Delete]="${terminfo[kDC5]}"

# Reserved for PageDown and PageUp.
# Because zsh can't control terminal
# emulator scroll.
_do_nothing() {}
zle -N _do_nothing

# Bind them (skipped if the terminal doesn't have that key).
[[ -n "${key[Home]}"           ]] && bindkey -- "${key[Home]}"           beginning-of-line
[[ -n "${key[End]}"            ]] && bindkey -- "${key[End]}"            end-of-line
[[ -n "${key[Delete]}"         ]] && bindkey -- "${key[Delete]}"         delete-char
[[ -n "${key[PageUp]}"         ]] && bindkey -- "${key[PageUp]}"         _do_nothing
[[ -n "${key[PageDown]}"       ]] && bindkey -- "${key[PageDown]}"       _do_nothing
[[ -n "${key[Shift-Tab]}"      ]] && bindkey -- "${key[Shift-Tab]}"      reverse-menu-complete
[[ -n "${key[Control-Left]}"   ]] && bindkey -- "${key[Control-Left]}"   backward-word
[[ -n "${key[Control-Right]}"  ]] && bindkey -- "${key[Control-Right]}"  forward-word
[[ -n "${key[Control-Delete]}" ]] && bindkey -- "${key[Control-Delete]}" kill-word

# Ctrl+Backspace has no terminfo name. Konsole usually sends ^H.
bindkey '^H' backward-kill-word

# Put the terminal in "application mode" while editing a line.
# Only then do the terminfo sequences above match what the keys send.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function zle_application_mode_start { echoti smkx }
  function zle_application_mode_stop { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
