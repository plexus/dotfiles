export ZPREZTO_HOME="${ZDOTDIR:-$HOME}/.zprezto"

# Install ZPrezto if missing

if [[ ! -d "$ZPREZTO_HOME" ]] ; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "$ZPREZTO_HOME"
    setopt EXTENDED_GLOB
    for rcfile in "$ZPREZTO_HOME}"/runcoms/^README.md(.N); do
        ln -s "$rcfile" "${ZPREZTO_HOME}/.${rcfile:t}"
    done
fi

# Source Zprezto

if [[ -s "${ZPREZTO_HOME}/init.zsh" ]]; then
  source "${ZPREZTO_HOME}/init.zsh"
fi

# Customize to my needs

# prevent sub-shells (i.e. tmux) from repeating what's already done
if [[ -z "$PLEXUS_INIT_DONE" ]] ; then
    source /usr/local/share/chruby/chruby.sh
    chruby ruby-2.4.2

    # Needs to run before $PREFIX is set or nvm will complain
    source ~/.nvm/nvm.sh
    nvm use --silent 5

    #source $HOME/github/choes/share/choes/choes.sh
    #source $HOME/github/choes/share/choes/choes-chruby.sh

    # For XMonad + Java apps
    export _JAVA_AWT_WM_NONREPARENTING=1

    export EDITOR=emacsclient
    export LC_ALL=en_US.UTF-8
    export HISTFILE="$HOME/.zhistory"
    export PREFIX="/home/arne/opt"
    export JRUBY_OPTS="-J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify"
    export PATH=$HOME/bin:$HOME/opt/bin:$PATH:$HOME/opt/android-sdk-linux/tools:$HOME/opt/android-sdk-linux/platform-tools:$HOME/opt/clojure-scripts/bin
    export PLEXUS_INIT_DONE="OK"
fi

prompt adam1

# Allow redirection to overwrite files.
setopt CLOBBER

# Share recent history between shells
setopt SHARE_HISTORY

HISTSIZE=50000
SAVEHIST=50000

alias top=htop
alias l='ls -1 --color'
alias acs='apt-cache search'
alias ai='sudo apt-get install'
alias grep='grep --exclude-dir .svn --exclude-dir .git --exclude tags --exclude TAGS --color=auto'

alias churby=chruby
alias gerp=grep
alias nnn='ruby -e "puts ARGV.pop.codepoints.inject(:+)%97"'

alias bx='bundle exec'

alias -g SU=' | sort | uniq'
alias -g EC=' |
while read line
do
  echo $line >&2
  echo ${line/*home/\/home} | sed "s/:\([0-9]\+\).*/:\1/" | read fn
  emacsclient +${fn//*:/} ${fn//:*/}
done'

function en {
    EMACSCLIENT=${EMACSCLIENT:-emacsclient}
    if [[ "$1" =~ ':' ]]; then
        ${=EMACSCLIENT} -n +${1//*:/} ${1//:*/}
    else
        ${=EMACSCLIENT} -n $1
    fi
}

alias -g FF="| sed 's/\([^:]* \|^\)\([-\/a-zA-Z0-9_\.]\+:[0-9]\+\).*/\2/'"

# Go to last opened directory when new terminal is opened
function store-current-path() {
  echo -n `pwd` >! /run/shm/current-path
}
if [[ ! "$precmd_functions" == *store-current-path* ]]; then
    precmd_functions+=("store-current-path")
fi
[[ -e /run/shm/current-path ]] && cd `cat /run/shm/current-path`
# end

if [ ! "$INSIDE_EMACS" = "" ]; then
  function emacs-store-path() {
    emacsclient --eval "(setq plexus-shell-extra-info \"$(echo -n `pwd`)\")" >> /dev/null
  }
  if [[ ! "$precmd_functions" == *emacs-store-path* ]]; then
    precmd_functions+=("emacs-store-path")
  fi
fi

### START-Keychain ###
# Let  re-use ssh-agent and/or gpg-agent between logins
/usr/bin/keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/$(echo -n `hostname`)-sh
### End-Keychain ###

export ANSIBLE_NOCOWS=1

alias ed="rlwrap ed -p'> '"
