# The config dir should always be expected to be /etc/zsh
# do not change this.
local zcfg_config_dir="/etc/zsh"

local zcfg_environment_dir="$zcfg_config_dir/environment"

local zcfg_static_env_file="/etc/environment.d/50-enuf.conf"

# The expected primary user(s)
# if matches username turns yellow.
local zcfg_primary_users=("viktor")
local zcfg_primary_user_prompt_color=11  # bright yellow

# Configs the primary hostname.
# If it matches then hostname turns blue.
local zcfg_primary_hosts=("archer")
local zcfg_primary_host_prompt_color=12  # bright blue


local zcfg_other_user_prompt_color=10    # bright green
local zcfg_other_host_prompt_color=13    # pink
local zcfg_root_prompt_color=red
