#OS
OS=`uname -s`

#generic setup
set -o vi

#editor
if [ -f /usr/bin/vim ]; then
  export EDITOR=/usr/bin/vim
else
  export EDITOR=/usr/bin/vi
fi

#pager
if [ -f /usr/bin/less ]; then
  export PAGER=/usr/bin/less
else
  export PAGER=/bin/more
fi

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

# Set git autocompletion and PS1 integration
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
  . /usr/local/git/contrib/completion/git-completion.bash
fi
if [ -f /opt/local/share/doc/git-core/contrib/completion/git-prompt.sh ]; then
    . /opt/local/share/doc/git-core/contrib/completion/git-prompt.sh
fi
GIT_PS1_SHOWDIRTYSTATE=true

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

#PS1 change color if you use this bashrc as root
if [ $(id -u) -eq 0 ]; then
  export PS1="\[$(tput bold)\]\[$(tput setaf 1)\]\u\[$(tput setaf 7)\]@\h:\W\[$(tput setaf 1)\]\$(__git_ps1)\[$(tput setaf 7)\] \$ \[$(tput sgr0)\]"
else
  export PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\u\[$(tput setaf 7)\]@\h:\W\[$(tput setaf 1)\]\$(__git_ps1)\[$(tput setaf 7)\] \$ \[$(tput sgr0)\]"
fi

#functions
#check and add path if it exists
function pathadd {
  if [ -d $1 ];then
    export PATH=$PATH:$1
  fi
}

#brew path mangle fiunction if brew installed
if [ -f /usr/local/bin/brew ]; then
  function brewpath {
  echo "Mangling your PATH to catch brew installed things first"
  echo "Highly likely to act weirdly"
  export PATH=/usr/local/bin:$PATH
 }
fi

#Some common places I like to put tools in my home dir
pathadd $HOME/bin/dtrace
pathadd $HOME/bin

# debian bash competion when it exists
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# history timestamps and size
export HISTTIMEFORMAT="%F %T "
export HISTFILESIZE=10000
export HISTSIZE=10000
