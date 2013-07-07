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
#PS1 change color if you use this bashrc as root
if [ $(id -u) -eq 0 ]; then
  export PS1="\[$(tput bold)\]\[$(tput setaf 1)\]\u\[$(tput setaf 7)\]@\h \W \\$ \[$(tput sgr0)\]"
else
  export PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\u\[$(tput setaf 7)\]@\h \W \\$ \[$(tput sgr0)\]"
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
