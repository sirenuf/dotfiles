warning_printed=false

function command_exists {
  local command_name=$1

  command -v $command_name &> /dev/null
}

function alias_if_exists {
  local alias_name=$1
  local arguments=$2

  local command_names

  shift 2
  if (( $# > 0 )); then
    command_names=($@);         # There are multiple commands
  else
    command_names=($alias_name) # There is only one command
  fi

  local command_name
  for command_name in $command_names;
  do

    if command_exists $command_name
    then
 
      local alias_string="$command_name"

      # If string is not empty
      if [[ -n $arguments ]]
      then
        alias_string+=" $arguments"
      fi
 
      alias $alias_name="$alias_string"
      return;
    fi

  done


  # Do not show errors if zsh has started already one time.
  if [[ -f $ZSH_ALIASES_CACHED_FILE ]]
  then
    return;
  fi

  # No commands found
  if [[ $warning_printed == false ]]
  then
    print -u2 -P "%B%F{red}WARNING%f:%b can't find command(s):";
    warning_printed=true
  fi

  print -u2 -P "\t%B$command_names%b"
}


