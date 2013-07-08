#vim
if [ -d $HOME/.vim ]; then
    mv $HOME/.vim $HOME/.vim_orig
fi
ln -s $HOME/dotfiles/vim.symlink .vim
echo ":so ~/dotfiles/vimrc" >> ~/.vimrc

#bash
cat << 'EOF' >> $HOME/.bashrc
# Source common bashrc file
. $HOME/dotfiles/bashrc
EOF

#git
cat << 'EOF' >> $HOME/.gitconfig
[include]
  path = ~/dotfiles/gitconfig.home
  path = ~/dotfiles/gitconfig
EOF
