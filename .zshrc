. ~/bin/setup_path

# Tramp - https://blog.karssen.org/2016/03/02/fixing-emacs-tramp-mode-when-using-zsh/
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# For XMonad + Java apps
export _JAVA_AWT_WM_NONREPARENTING=1

export EDITOR=emacsclient
export LC_ALL=en_US.UTF-8
export JRUBY_OPTS="-J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify"

# Allow redirection to overwrite files.
setopt CLOBBER

# Share recent history between shells
export HISTFILE="$HOME/.zhistory"
setopt SHARE_HISTORY
HISTSIZE=50000
SAVEHIST=50000
export WORDCHARS="*?_-.[]~&;!#$%^(){}<>"

export ANSIBLE_NOCOWS=1

alias top=htop
alias l='ls -1 --color'
alias ls='ls --color'
alias acs='apt-cache search'
alias grep='grep --exclude-dir .svn --exclude-dir .git --exclude tags --exclude-dir node_modules --exclude TAGS --color=auto'
alias ed="rlwrap ed -p'> '"
alias ducks='while read -r line;do du -sh "$line";done < <(ls --color=never -1A) | sort -rh | head -n11'

alias churby=chruby
alias gerp=grep
alias nnn='ruby -e "puts ARGV.pop.codepoints.inject(:+)%97"'

alias bx='bundle exec'
alias apt-full-upgrade='sudo apt-get update && sudo apt-get dist-upgrade -y --autoremove'

function ai {
    echo "$@" >> ~/repos/dotfiles/extra_packages
    sudo apt-get install -y --auto-remove "$@"
}

function en {
    EMACSCLIENT=${EMACSCLIENT:-emacsclient}
    if [[ "$1" =~ ':' ]]; then
        ${=EMACSCLIENT} -n +${1//*:/} ${1//:*/}
    else
        ${=EMACSCLIENT} -n $1
    fi
}

function termtitle() {
    echo -e "\033]0;$1\007"
}

### Go to last opened directory when new terminal is opened ###
function store-current-path() {
  echo -n `pwd` >! /run/shm/current-path
}
if [[ ! "$precmd_functions" == *store-current-path* ]]; then
    precmd_functions+=("store-current-path")
fi
[[ -e /run/shm/current-path ]] && cd "$(cat /run/shm/current-path)"
### /last opened directory ###


### SSH Keychain ###
# Let re-use ssh-agent and/or gpg-agent between logins
if [ -x '/usr/bin/ksshaskpass' ]; then
    export GIT_ASKPASS='/usr/bin/ksshaskpass'
    export SSH_ASKPASS='/usr/bin/ksshaskpass'
    export SSH_ASKPASS_REQUIRE=prefer
fi
if [ -x "/usr/bin/keychain" ]; then
    if [ -f "$HOME/.ssh/id_rsa" ]; then
        eval $(/usr/bin/keychain --quiet --quick --eval $HOME/.ssh/id_rsa)
    elif [ -f "$HOME/.ssh/id_ed25519" ]; then
        eval $(/usr/bin/keychain --quiet --quick --eval $HOME/.ssh/id_ed25519)
    fi
fi
### /SSH Keychain ###

### Spaceship ZSH prompt ###
if [ ! -f "$HOME/repos/spaceship-prompt/spaceship.zsh" ]; then
	mkdir -p "$HOME/repos"
	git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/repos/spaceship-prompt"
fi
source "$HOME/repos/spaceship-prompt/spaceship.zsh"
export SPACESHIP_DIR_TRUNC_REPO=false
#SPACESHIP_PROMPT_ORDER=(time user dir host git hg package node ruby docker aws kubecontext terraform exec_time perry line_sep battery jobs exit_code char)
SPACESHIP_PROMPT_ORDER=(time user dir host git hg package node ruby aws terraform exec_time line_sep battery jobs exit_code char)
### /Spaceship ZSH prompt ###

### Chruby ###
if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
    source /usr/local/share/chruby/chruby.sh
    chruby $(chruby | tail -1 | sed 's/.* //')
fi
### End Chruby ###

if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
. "$HOME/.asdf/asdf.sh"
fi

export RUNELEVEN_DIR=/home/arne/Eleven/runeleven

# export CLOUDSDK_PYTHON=/usr/bin/python3.8

if [ -f /usr/share/google-cloud-sdk/completion.zsh.inc ]; then . /usr/share/google-cloud-sdk/completion.zsh.inc ; fi

if [ -d "$HOME/repos/zsh-completions" ]; then
    fpath=("$HOME/repos/zsh-completions/src" $fpath)
fi

# Make pipewire act as a jack server
export LD_LIBRARY_PATH='/usr/${LIB}/pipewire-0.3/jack'"${LD_LIBRARY_PATH+":$LD_LIBRARY_PATH"}"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/arne/.sdkman"
[[ -s "/home/arne/.sdkman/bin/sdkman-init.sh" ]] && source "/home/arne/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="/home/arne/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/arne/.bun/_bun" ] && source "/home/arne/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# export CLOUDSDK_PYTHON_SITEPACKAGES=1
# export CLOUDSDK_PYTHON=$HOME/opt/gcloud-venv/bin/python

# fnm
FNM_PATH="/home/arne/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/arne/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/arne/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/home/arne/opt/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/arne/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/arne/opt/google-cloud-sdk/completion.zsh.inc'; fi

if [ -x '/usr/bin/vim.gtk3' ]; then
    alias vim=vim.gtk3
fi


# lambdaisland.cli completions
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
compinit
compdef _licli /tmp/test/bin/dev '*/dev' dev
compdef _licli /home/arne/Gaiwan/Oak/bin/oakadm '*/oakadm' oakadm

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
