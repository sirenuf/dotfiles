#!/bin/zsh
zparseopts -D -E -F -- \
  -overwrite-user-cfgs=opt_overwrite \
  -no-system=opt_nosys \
  -no-user=opt_nouser  \
  -system=opt_systemonly \
  h=opt_help -help=opt_help || exit 1

local absolute_script_path="${0:A}"

local local_root_dir="root"
local local_user_dir="main_user"

local is_there_a_user_conflict=false

local user_home=$HOME

# Help command
if (( $#opt_help )); then
  print "install.sh:"
  print "A script which by default installs my config, globally and at a user level."
  print ""
  print "Flags:"
  print "\t--help:                   displays this message"
  print "\t--no-system:              skips everything in $local_root_dir, and anything that requires elevation"
  print "\t--no-user:                skips everything in $local_user_dir"
  print "\t"
  print "\t--overwrite-user-cfgs:    always overwrites conflicting files in \$HOME"
  print "\t--system:                 not intended to be used by users. Script uses it on itself for elevation and ignores all other flags and usual program flow."

  exit 0
fi


# Get access to a proper elevate command
function root_check_elevate_commands()
{
  if   (( $+commands[sudo] )); then elevate=sudo
  elif (( $+commands[doas] )); then elevate=doas
  elif (( $+commands[run0] )); then elevate=run0
  else
    print "Need sudo, doas or run0."
    exit 1
  fi
}

function root_install_global_cfg()
{
  # Back up code
  #
  # Config should only be backed up if /etc/zsh exists, and the 
  # config is not already installed. (/etc/zsh/environment/)
  if [[ -d "/etc/zsh" && ! -d "/etc/zsh/environment" ]]
  then
    # If config is not installed, but there is a /etc/zsh global
    # directory and a backed up directory simultaneously, then
    # something is wrong and we need to exit.
    if [[ -d "/etc/zsh.bak" ]]; then
      echo "Stopping because there is already a /etc/zsh.bak folder, but no previous config was already installed."
      echo "Delete the old backup to continue."
      exit 1
    fi

    # Backup the original config
    mv "/etc/zsh" "/etc/zsh.bak" || exit 1
  fi

  rsync -r --chown=root:root "$local_root_dir/." "/" || exit 1
}

function common_cd_to_projectroot()
{
  # :h strips the filename so it only points to the directory containing the path
  cd "${absolute_script_path:h}" || exit 1
}

function common_initialise_interactive_script()
{
  if (( $#opt_nouser && $#opt_nosys )); then
    echo "There is nothing to do."
    exit 0
  fi

  if [[ ! -d "$user_home" ]] && (( ! $#opt_nouser )); then
    echo "Home directory '$user_home' does not exist."
    exit 1
  fi

  echo "Home folder is: $user_home"

  while [[ "$ans" != [YyNn] ]]; do
    local _prompt=""
    if (( $#opt_nosys )); then
      _prompt="Install to '$HOME' only?"
    elif (( $#opt_nouser )); then
      _prompt="Install to your system globally only?"
    else
      _prompt="Install to your user and system?"
    fi

    read -r "ans?$_prompt [y/n] "
  done

  if [[ "$ans" == [Nn] ]]; then
    exit 0
  fi
}

function common_check_vital_dependencies()
{
  local deps=(
    rsync
  )

  local missing=()

  for dep in $deps
  do
    if (( ! $+commands[$dep] )); then missing+=$dep; fi
  done

  if (( ${#missing} > 0 )); then
    echo "Missing dependencie(s): $missing"
    exit 1
  fi
}

function user_check_for_conflicts_in_home()
{
  cd $local_user_dir || exit 1

  # If no option to overwrite home was passed, check
  if (( ! $#opt_overwrite )); then
    for file_path in **/*(D.N)
    do
      if [[ -e "$user_home/$file_path" || -L "$user_home/$file_path" ]]; then
        is_there_a_user_conflict=true
        echo "Found conflicting file '$user_home/$file_path', so skipping file copy to user home completely. Add --overwrite-user-cfgs to ignore"
        
        break
      fi
    done
  fi

  cd .. || exit 1
}

function user_install_user_cfg_to_home()
{
  if [[ $is_there_a_user_conflict == false ]]; then
    rsync -r --chown=$USER:$USER "$local_user_dir/." "$user_home" || exit 1
    return 0
  fi

  return 1
}

function run_script()
{
  # Make sure we are in the working directory
  common_cd_to_projectroot
  common_check_vital_dependencies

  if (( $#opt_systemonly )); then
    root_install_global_cfg
    exit
  fi

  common_initialise_interactive_script

  # If system is not unchecked then install the global config. 
  if (( ! $#opt_nosys )); then
    # If user is running this as root or sudo already, no need to check for a elevation command.
    if (( $UID != 0 )); then
      root_check_elevate_commands
    fi

    # Re-run the script in system-only mode
    $elevate "$absolute_script_path" --system || exit 1
  
    echo "Installed the global config."
  fi

  # Handle user stuff
  if (( ! $#opt_nouser )); then
    user_check_for_conflicts_in_home
    user_install_user_cfg_to_home && echo "Installed the user config to '$user_home'"
  fi
}

run_script
