() {
local user_color
local hostname_color

local prompt_symbol

local user hostname

user_color=$zcfg_other_user_prompt_color
for user in $zcfg_primary_users
do
  if [[ $USER == $user ]]
  then
    user_color=$zcfg_primary_user_prompt_color
  fi
done

hostname_color=$zcfg_other_host_prompt_color # pink
for hostname in $zcfg_primary_hosts
do
  if [[ $HOST == $hostname ]]
  then
    hostname_color=$zcfg_primary_host_prompt_color
  fi
done

# If not root
if (( $UID > 0 ))
then
  prompt_symbol=">"
else
  user_color=$zcfg_root_prompt_color # red colour for root
  prompt_symbol="#"
fi

PROMPT="%B[%b%F{$user_color}%n%f@%F{$hostname_color}%m%f %B%F{white}%~%f]%b"$'\n'"$prompt_symbol "
}
