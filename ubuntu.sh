#!/usr/bin/env bash

shopt -s extglob

cd "$(dirname "${BASH_SOURCE}")";

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit
fi

packages="
  build-essential
  zsh
  neovim
  ack
  git
  tmux
  tree
"

if ! dpkg -s $packages >/dev/null 2>&1; then
  echo "Found uninstalled packages"
  echo "Updating apt repositories"
  sudo apt-get update -qq
fi

for package in $packages; do
  if ! dpkg -s $package >/dev/null 2>&1; then
    echo "Installing package '$package'"
    sudo apt-get install -qq -y $package
  fi
done

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
    echo "Not linking '$dest' because file already exists"
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
