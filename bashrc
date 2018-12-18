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
if [ -f ~/dotfiles/bin/vimpager/vimpage ]; then
    export PAGER=~/dotfiles/bin/vimpager/vimpager
    alias less=$PAGER
else
    PAGER=/usr/bin/less
fi

alias vimcat=~/dotfiles/bin/vimpager/vimcat

eval "$(chef shell-init bash)"

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

#java home
ISJAVA=`which java`
if [ -f $ISJAVA ]; then
    export JAVA_HOME=`echo $ISJAVA|sed 's/\/bin\/java//'`
fi

#ec2 tools
if [ -d /opt/ec2-api-tools/bin/ ]; then
  export EC2_HOME=/opt/ec2-api-tools
  export PATH=$PATH:/${EC2_HOME}/bin
fi

#iam tools /opt/IAMCli
if [ -d /opt/IAMCli ]; then
  export AWS_IAM_HOME=/opt/IAMCli
  export PATH=${PATH}:/${AWS_IAM_HOME}/bin
fi

# tmux guard session
function muxguard() {
    if [[ $1 == "init" ]];then
        tmux new-session -s guard-generic
        return
    else
        if [[ -f Guardfile ]];then
            tmux list-sessions | grep ^guard-generic > /dev/null
            if [[ $? -ne 0 ]]; then
                echo "No tmux guard-generic session: start one with \"muxguard init\""
            else
                echo "starting guard in existing tmux guard-generic session"
                tmux send-keys "cd `pwd`; bundle exec guard" C-m
            fi
        fi
    fi
}

#Some common places I like to put tools in my home dir
pathadd $HOME/bin/dtrace
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

# Try to launch an ssh-agent if no other keychain has done so
RUNNING_SSH_AGENT_PID=`ps -u $USER | grep ssh-agen | awk '{ print $1 }'`
if [ "_${RUNNING_SSH_AGENT_PID}" == "_" ]; then
    eval `ssh-agent`
    ssh-add
else
    # Do we have an ssh socket available already? (gnome keyring etc)
    if [ "_${SSH_AUTH_SOCK}" == "_" ]; then
        let SSH_AGENT_PID=$RUNNING_SSH_AGENT_PID-1

        # Try and grab hold of an existing ssh-agent
        SSH_TMPDIR=`ls -dl /tmp/ssh-* | grep $USER | awk '{ print $9 }'`
        if [ -S ${SSH_TMPDIR}/agent.${SSH_AGENT_PID} ]; then
            export SSH_AUTH_SOCK=${SSH_TMPDIR}/agent.${SSH_AGENT_PID}
            export SSH_AGENT_PID
        fi
    fi
fi

# rbenv for managing ruby envs
which rbenv 1>/dev/null
if [ $? -eq 0 ]; then
    eval "$(rbenv init -)"
fi

#AWS stuff if it exists
if [ -f ~/.aws-secrets ];then
    . ~/.aws-secrets
fi
#IAM has yet another key format
if [ -f ~/.aws-creds ];then
    export AWS_CREDENTIAL_FILE=~/.aws-creds
fi

#local extras
if [ -f ~/.bashrc.extra ];then
    . ~/.bashrc.extra
fi

if [ -d ~/dotfiles/bin ]; then
    export PATH="~/dotfiles/bin":$PATH
fi

function bbc(){
    git clone git@bitbucket.org:conversocial/$1.git
    if [[ $? -eq 0 ]]; then
        cd $1
    else
        echo "Failed to clone git@bitbucket.org:conversocial/$1.git"
    fi
}

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
