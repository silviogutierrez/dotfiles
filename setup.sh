#!/bin/bash
set -e
set -x

brew cask
brew cask install dropbox
brew install vim
brew install mackup

# Dropbox needs to be finished for this to run.
# mackup restore --force

# So we download the vimrc manually.
curl https://raw.githubusercontent.com/silviogutierrez/dotfiles/master/.vimrc > ~/.vimrc
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +BundleInstall +qall
cd ~/.vim/bundle/Command-T/ruby/command-t/ext/command-t
PATH="/usr/local/opt/ruby/bin:$PATH" ruby extconf.rb
make

brew cask install google-chrome

brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# No longer needed.
# brew install mysql@5.6
# brew services start mysql@5.6
# brew link --force mysql@5.6

brew cask install docker
brew cask install iterm2

brew install dnsmasq
echo 'address=/.localhost/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf
sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/localhost'
sudo brew services start dnsmasq

# Python 3 is already installed by brew for other packages.
pip3 install tmuxp

brew cask install spectacle
# brew cask install microsoft-office microsoft-teams
brew cask install visual-studio-code

brew cask install google-cloud-sdk

# For Joy and secret encryption.
brew install shyiko/kubesec/kubesec
brew install postgresql@11
brew services start postgresql@11

# Until we figure out how to do it with nix or npm inside nix.
# See https://github.com/NixOS/nixpkgs/issues/65387
# brew install ios-deploy
# Maybe we can use capacitor instead of cordova?

# Nix formula is currently linux only.
brew cask install android-studio
brew cask install signal
