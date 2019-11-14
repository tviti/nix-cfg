# TODO: Use Nix conda so we don't have to deal with this shit anymore.
# added by Anaconda2 5.0.0 installer
# export PATH="/Users/taylor/anaconda2/bin:$PATH"  # commented out by conda initialize

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/taylor/anaconda2/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/taylor/anaconda2/etc/profile.d/conda.sh" ]; then
#         . "/Users/taylor/anaconda2/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/taylor/anaconda2/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

# Needed to get Expect package to work
export TCLLIBPATH="/usr/local/lib"

if [ -e /Users/taylor/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/taylor/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Source the home-manager session vars
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
