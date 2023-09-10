fpath=($fpath "/home/arne/.zfunctions")
autoload -U promptinit; promptinit
prompt spaceship

alias en='emacsclient -n'

export PATH="$HOME/bin:$HOME/monorepo/projects/csp-billing-dev/bin:$PATH"

export HISTFILE="$HOME/.zhistory"
setopt SHARE_HISTORY
HISTSIZE=50000
SAVEHIST=50000

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"