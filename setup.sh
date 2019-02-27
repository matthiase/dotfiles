#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit
fi

xcode-select --version
if [[ $? != 0 ]] ; then
  echo "Installing XCode Command Line Tools"
  xcode-select --install
fi

which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install zsh
  brew install readline
  brew install openssl
  brew install ncurses
  brew install neovim
  brew install ack
  brew install git
  brew install tmux
  brew install tree
  brew install ssh-copy-id
  brew cask install iterm2
  brew tap caskroom/fonts
  brew cask install font-hack-nerd-font
  brew tap sambadevi/powerlevel9k
  brew install powerlevel9k
else
  echo "Upgrading Homebrew packages"
  brew update
  brew upgrade
  brew cleanup
fi

echo $SHELL

if [ -z "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
  chsh -s /bin/zsh
fi

rsync --exclude ".git/" \
  --exclude ".DS_Store" \
  --exclude "update.sh" \
  --exclude "README.md" \
  --exclude "LICENSE" \
  --exclude "colors" \
  -avh --no-perms . ~

