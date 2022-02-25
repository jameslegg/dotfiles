#OS
OS=`uname -s`

#generic setup
set -o vi

alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

#editor
if [ -f /usr/local/bin/nvim ]; then
  export EDITOR=/usr/local/bin/nvim
  alias vim=/usr/local/bin/nvim
elif [ -f /usr/bin/vim ]; then
  export EDITOR=/usr/bin/vim
else
  export EDITOR=/usr/bin/vi
fi

PAGER=/usr/bin/less

alias vimcat=~/dotfiles/bin/vimpager/vimcat

# enable color support of ls and also add handy aliases
# (from ubuntu's default bashrc)
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
elif [ "${OS}" == "Darwin" ]; then
    alias ls='ls -G'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# bash tab completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Set git autocompletion and PS1 integration
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
  . /usr/local/git/contrib/completion/git-completion.bash
fi
if [ -f /opt/local/share/doc/git-core/contrib/completion/git-prompt.sh ]; then
    . /opt/local/share/doc/git-core/contrib/completion/git-prompt.sh
fi
GIT_PS1_SHOWDIRTYSTATE=true

# https://coderwall.com/p/s-2_nw/change-iterm2-color-profile-from-the-cli
# iTerm2 Profile selection
# This has a habit of messing up shell prompts hence the blank line
it2prof() {
    echo -en "\033]50;SetProfile=$1\a"
}

function mykube_shell {
    context=`/usr/local/bin/kubectl config current-context`
    if [[ $context == *prod* || $AWS_PROFILE == *prod* ]]; then
        # Danger Will Robinson!
        it2prof "rootLive"
        PS1_WARN=🚨
    else
        it2prof "Default"
        PS1_WARN=""
    fi
}

PROMPT_COMMAND=mykube_shell

alias mykube_ps1='echo \☸️ -\>`/usr/local/bin/kubectl config current-context` $PS1_WARN\'

#PS1 change color if you use this bashrc as root
if [ $(id -u) -eq 0 ]; then
  export PS1="\[$(tput bold)\]\[$(tput setaf 1)\]\u\[$(tput setaf 7)\]@\h:\W\[$(tput setaf 1)\]\$(__git_ps1)\[$(tput setaf 7)\] \$ \[$(tput sgr0)\]"
else
    export PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\u\[$(tput setaf 7)\]@\h:\W\[$(tput setaf 1)\]\$(__git_ps1)\[$(tput setaf 7)\] \$(mykube_ps1)\$ \[$(tput sgr0)\]"
fi

#functions
#check and add path if it exists
function pathadd {
  if [ -d $1 ];then
    export PATH=$PATH:$1
  fi
}

#brew path mangle function if brew installed
if [ -f /usr/local/bin/brew ]; then
  function brewpath {
  echo "Mangling your PATH to catch brew installed things first"
  echo "Highly likely to act weirdly"
  export PATH=/usr/local/Cellar/ruby/1.9.2-p290/bin:/usr/local/bin:$PATH
 }
 # Add stuff installed by brew to the front of our path
 export PATH="/usr/local/sbin:$PATH"
fi

pathadd $HOME/bin

# ChefDK
pathadd /opt/chefdk/bin

# debian bash competion when it exists
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# history timestamps and size
export HISTTIMEFORMAT="%F %T "
export HISTFILESIZE=10000
export HISTSIZE=10000

#locked down /tmp
MYTMP="/tmp/${USER}"
mkdir -p $MYTMP
chmod 700 $MYTMP

#local extras
if [ -f ~/.bashrc.extra ];then
    . ~/.bashrc.extra
fi

if [ -d ~/dotfiles/bin ]; then
    export PATH="~/dotfiles/bin":$PATH
fi

function ghc(){
    git clone git@github.com:$1.git
    if [[ $? -eq 0 ]]; then
        mcd=$(echo $1 | awk '{ split($0,r,"\/"); print r[2]}')
        cd $mcd
    else
        echo "Failed to clone git@github.com:$1.git"
    fi
}

if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
    source /usr/local/etc/bash_completion.d/git-prompt.sh
fi

if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    source /usr/local/etc/bash_completion.d/git-completion.bash
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi
