#!/usr/bin/env bash

shopt -s extglob

cd "$(dirname "${BASH_SOURCE}")";

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit
fi

#xcode-select --version > /dev/null 2>&1
#if [[ $? != 0 ]] ; then
#  echo "Installing XCode Command Line Tools"
#  xcode-select --install
#fi

#which -s brew > /dev/null 2>&1
#if [[ $? != 0 ]] ; then
#  echo "Installing Homebrew"
#  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#else
#  echo "Updating Homebrew"
#  brew update
#fi

#for formula in zsh \
#  readline \
#  openssl \
#  ncurses \
#  neovim \
#  ack \
#  git \
#  tmux \
#  tree \
#  ssh-copy-id ;
#do
#  echo "Checking formula '$formula'"
#  brew ls --versions $formula > /dev/null 2>&1
#  if [[ $? != 0 ]] ; then
#    brew install $formula
#  fi
#done

#brew tap caskroom/fonts > /dev/null 2>&1
#casks=("font-hack-nerd-font")
#if [ ! -d /Applications/iTerm.app ] ; then
#  casks+=(iterm2)
#fi
#
#for cask in "${casks[@]}" ; do
#  echo "Checking cask '$cask'"
#  brew cask ls --versions $cask > /dev/null 2>&1
#  if [[ $? != 0 ]] ; then
#    brew cask install $cask
#  fi
#done

if [ ! -e $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
  curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/matthiase/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/!(README.md); do
  dest="${ZDOTDIR:-$HOME}/.$(basename $rcfile)"
  if [ ! -e $dest ]; then
    echo "Linking $dest"
    ln -s "$rcfile" "${ZDOTDIR:-$dest}"
  else
    echo "Not linking '$dest' because file already exists."
  fi
done

if [ -z "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
  chsh -s /bin/zsh
fi

rsync --exclude ".git/" \
  --exclude ".DS_Store" \
  --exclude "macos.sh" \
  --exclude "ubuntu.sh" \
  --exclude "README.md" \
  --exclude "LICENSE" \
  --exclude "colors" \
  -avh --no-perms . ~

