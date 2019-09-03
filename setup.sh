#!/bin/bash
set -e

brew cask
brew install dropbox
brew install vim
brew install mackup
mackup restore

mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +BundleInstall +qall
cd ~/.vim/bundle/Command-T/ruby/command-t/ext/command-t
PATH="/usr/local/opt/ruby/bin:$PATH" ruby extconf.rb
make

brew cask install google-chrome
