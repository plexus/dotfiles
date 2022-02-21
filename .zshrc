append_path () {if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then PATH="$PATH:$1" fi}
prepend_path () {if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then PATH="$1:$PATH" fi}

export PREFIX=/home/arne/opt

prepend_path $HOME/bin
prepend_path $HOME/opt/bin
prepend_path $HOME/.cargo/bin

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
/usr/bin/keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/$(echo -n `hostname`)-sh
### /SSH Keychain ###


### Go ###
export GOPATH="$HOME/tmp/gocode"
append_path "$GOPATH/bin"
### /Go ###


### Spaceship ZSH prompt ###
if [[ -f "$HOME/.zfunctions/prompt_spaceship_setup" ]]; then
   fpath=($fpath "$HOME/.zfunctions")
   export SPACESHIP_KUBECONTEXT_SHOW=false
   autoload -U promptinit; promptinit
   prompt spaceship
else
    echo "Spaceship prompt not found, try npm install -g spaceship-prompt"
fi
### /Spaceship ZSH prompt ###


### Android Studio ###
if [[ -d "$HOME/opt/Andriod" ]]; then
    export ANDROID_HOME=$HOME/opt/Android/Sdk
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH:/snap/bin:/usr/local/bin"
    export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
fi
### /Android Studio ###


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

SPACESHIP_PROMPT_ORDER=(time user dir host git hg package node ruby docker aws kubecontext terraform exec_time perry line_sep battery jobs exit_code char)

export PATH=/home/arne/.fnm:$PATH
eval "`fnm env`"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/arne/.sdkman"
[[ -s "/home/arne/.sdkman/bin/sdkman-init.sh" ]] && source "/home/arne/.sdkman/bin/sdkman-init.sh"
sdk use java 17-open
