#!/bin/bash

# - [ ] Run system update
# - [ ] Install Xcode in app store
# - [ ] Install 1Password in app store
# - [ ] Open XCode
# - [ ] Install brew
# - [ ] Install nix
# - [ ] Close terminal
# - [ ] Run bash -x setup.sh
# - [ ] Open dropbox and finish setup, all local no smart sync.
# - [ ] Open spectacle and finish setup
# - [ ] Wait a few minutes and verify `ls ~/Dropbox/Mackup` has dot files
# - [ ] Run `mackup restore --force`
# - [ ] Open android studio and finish setup
# - [ ] Turn off iMessage notification preview
# - [ ] Turn off iMessage notifications on lock screen. This wakes up the monitor.
# - [ ] Turn off WhatsApp notification preview
# - [ ] Turn on tap to click
# - [ ] Turn off alert volume
# - [ ] Turn on auto dock
# - [ ] Turn on SSH
# - [ ] Switch touch bar (preferences -> keyboard -> touch bar shows: Expanded control strip)
# - [ ] Sign in to Google in order: GMail, SGA Websites, Joy.
# - [ ] Remove recents as default in finder, and from sidebar
# - [ ] Turn on iTunes match
# - [ ] https://stackoverflow.com/a/45430155 . Edit: maybe not?
# - [ ] In Settings / Notifications / Do Not Disturb, enable "When the display is sleeping"
# - [ ] In Settings/ Keyboard / Shortcuts, prevent accidental Safari quit: https://alanhogan.com/tips/reduce-accidental-safari-quits
# - [ ] Turn off auto sleep
# - [ ] Hot corners: bottom right, Put Display to Sleep
# - [ ] Display goes to sleep 20 minutes.
# - [ ] Switch Finder Preferences, Advanced: search current folder.
# - [ ] https://nickjanetakis.com/blog/docker-tip-32-automatically-clean-up-after-docker-daily
# - [ ] Add ~/Sites to Spotlight Privacy exclusion in System Preferences for performance.

set -e
set -x

# See https://www.quora.com/How-can-I-completely-hide-or-remove-the-Dock-in-Mac-OS-X-Yosemite
defaults write com.apple.Dock autohide-delay -float 5 && killall Dock

brew cask
brew cask install google-drive-file-stream framer-x
# brew cask install cyberduck # SFTP client
brew cask install dropbox
brew install vim
brew install mackup
brew install kubectx

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
# brew install mysql
# If installing latest mysql, Navicat needs the below to connect.
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''
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

# See https://developer.apple.com/documentation/webkit/testing_with_webdriver_in_safari
sudo /usr/bin/safaridriver --enable
