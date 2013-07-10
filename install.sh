#!/bin/bash
# optionally specify home as first arg to include home specific settings

#OS
OS=`uname -s`

#vim
if [ -d $HOME/.vim ] && [ ! -L $HOME/.vim ]; then
    mv $HOME/.vim $HOME/.vim_orig
fi
if [ ! -L $HOME/.vim ]; then
    ln -s $HOME/dotfiles/vim.symlink $HOME/.vim
fi
#add include if not there already
grep "dotfiles/vimrc" $HOME/.vimrc  1>&2>/dev/null
if [ $? -ne 0 ]; then
    echo ":so ~/dotfiles/vimrc" >> $HOME/.vimrc
fi

#bash - just sourcing bash in case there is any good stuff in OS suplied bashrc
grep "dotfiles/bashrc" $HOME/.bashrc 1>&2>/dev/null
if [ $? -ne 0 ]; then
cat << 'EOF' >> $HOME/.bashrc
# Source common bashrc file
. $HOME/dotfiles/bashrc
EOF
fi

#git
if [ ! -L $HOME/.gitconfig ]; then
    if [ -f $HOME/.gitconfig ]; then
        mv $HOME/.gitconfig $HOME/.gitconfig_orig
    fi
    if [ "_$1" == "_home" ]; then
        ln -s $HOME/dotfiles/gitconfig.symlink.home $HOME/.gitconfig
    elif [ "$OS" == "Darwin" ]; then
        ln -s $HOME/dotfiles/gitconfig.symlink.mac $HOME/.gitconfig
    else
        ln -s $HOME/dotfiles/gitconfig.symlink $HOME/.gitconfig
    fi
fi
