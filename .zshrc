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
alias grep='grep --exclude-dir .svn --exclude-dir .git --exclude tags --exclude TAGS --color=auto'
alias ed="rlwrap ed -p'> '"

alias churby=chruby
alias gerp=grep
alias nnn='ruby -e "puts ARGV.pop.codepoints.inject(:+)%97"'

alias bx='bundle exec'

function ai {
    echo "$@" >> ~/github/dotfiles/extra_packages
    sudo apt-get install "$@"
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
[[ -e /run/shm/current-path ]] && cd `cat /run/shm/current-path`
### /last opened directory ###


### SSH Keychain ###
# Let re-use ssh-agent and/or gpg-agent between logins
export GIT_ASKPASS='/usr/bin/ksshaskpass'
export SSH_ASKPASS='/usr/bin/ksshaskpass'
export SSH_ASKPASS_REQUIRE=prefer
eval $(/usr/bin/keychain --quiet --quick --eval $HOME/.ssh/id_rsa)
### /SSH Keychain ###

### Spaceship ZSH prompt ###
source "$HOME/.zsh/spaceship/spaceship.zsh"
### /Spaceship ZSH prompt ###

### Chruby ###
if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
    source /usr/local/share/chruby/chruby.sh
    chruby $(chruby | tail -1 | sed 's/.* //')
fi
### End Chruby ###


export RUNELEVEN_DIR=/home/arne/Eleven/runeleven

export SPACESHIP_DIR_TRUNC_REPO=false

spaceship_perry() {
    local 'perry_instances'

    perry_instances="$(cat /tmp/perry.instances)"
    {
        cd /home/arne/github/lambdaisland/perry
        bin/perry summary > /tmp/perry.instances &
    } 2>&1 > /dev/null

    [[ -z "$perry_instances" ]] && return
    spaceship::section "yellow" "[" "$perry_instances" "]"
}

#SPACESHIP_PROMPT_ORDER=(time user dir host git hg package node ruby docker aws kubecontext terraform exec_time perry line_sep battery jobs exit_code char)
SPACESHIP_PROMPT_ORDER=(time user dir host git hg package node ruby aws terraform exec_time line_sep battery jobs exit_code char)

eval "`fnm env`"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/tmp/google-cloud-sdk/path.zsh.inc' ]; then . '/tmp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/tmp/google-cloud-sdk/completion.zsh.inc' ]; then . '/tmp/google-cloud-sdk/completion.zsh.inc'; fi

export CLOUDSDK_PYTHON=/usr/bin/python3.8

. /usr/share/google-cloud-sdk/completion.zsh.inc

fpath=("$HOME/github/zsh-completions/src" $fpath)

export LD_LIBRARY_PATH='/usr/${LIB}/pipewire-0.3/jack'"${LD_LIBRARY_PATH+":$LD_LIBRARY_PATH"}"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/arne/.sdkman"
[[ -s "/home/arne/.sdkman/bin/sdkman-init.sh" ]] && source "/home/arne/.sdkman/bin/sdkman-init.sh"
