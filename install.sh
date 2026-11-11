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
local local_darwin_dir="darwin"

local is_there_a_user_conflict=false

local user_home=$HOME

# Folders in `root/` that will get copied by any system are in this array.
# It is only on Linux were the entire `root/` folder is copied to `/`
local posix_reserved_folders=(
    "etc/zsh"
    "etc/environment.d"
)
local is_os_linux=false
local is_os_darwin=false

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

function common_set_os_type()
{
  case "$(uname -s)" in
    Darwin)
      is_os_darwin=true
      if [ -x "/opt/homebrew/bin/brew" ]; then
	echo "Applied brew env for Darwin."
	eval "$(/opt/homebrew/bin/brew shellenv)"
      else
	echo "No '/opt/homebrew/bin/brew' file found."
      fi
      ;;
    Linux)
      is_os_linux=true
      ;;
    *)
      echo "Your os type $(uname -s) is unsupported."
      exit 1
      ;;
  esac
}

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

function root_backup_darwin_zsh()
{
  if [[ ! -f "/etc/zshrc.bak" && -f "/etc/zshrc" ]]; then
    mv "/etc/zshrc" "/etc/zshrc.bak" || exit 1
  fi

  if [[ ! -f "/etc/zprofile.bak" && -f "/etc/zprofile" ]]; then
    mv "/etc/zprofile" "/etc/zprofile.bak" || exit 1
  fi

  if [[ ! -f "/etc/zshenv.bak" && -f "/etc/zshenv" ]]; then
    mv "/etc/zshenv" "/etc/zshenv.bak" || exit 1
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

  if [[ $is_os_linux == true ]]; then
    echo "Installing for target Linux."
    rsync -r --chown=0:0 "$local_root_dir/." "/" || exit 1

  elif [[ $is_os_darwin == true ]]; then
    echo "Installing for target OS X."
    for folder in $posix_reserved_folders; do
      rsync -r --chown=0:0 "$local_root_dir/$folder/" "/$folder" || exit 1
    done

    # Backup the original zsh files.
    root_backup_darwin_zsh
    # Then install the replacements.
    rsync -r --chown=0:0 "$local_darwin_dir/." "/etc/" 

  else
    echo "Can't install the config globally because your system type is unidentified."
    exit 1
  fi
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
    rsync -r --chown=$(id -un):$(id -gn) "$local_user_dir/." "$user_home" || exit 1
    return 0
  fi

  return 1
}

function run_script()
{
  # Make sure we are in the working directory
  common_cd_to_projectroot
  common_check_vital_dependencies
  common_set_os_type
  
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
