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

nerdfonts="
Hack/Bold/complete/Hack%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
Hack/BoldItalic/complete/Hack%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
Hack/Italic/complete/Hack%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
Mononoki/Bold-Italic/complete/mononoki%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
Mononoki/Bold/complete/mononoki%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
Mononoki/Italic/complete/mononoki%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
Mononoki/Regular/complete/mononoki-Regular%20Nerd%20Font%20Complete%20Mono.ttf
UbuntuMono/Bold-Italic/complete/Ubuntu%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
UbuntuMono/Bold/complete/Ubuntu%20Mono%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
UbuntuMono/Regular-Italic/complete/Ubuntu%20Mono%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
"
for nerdfont in $nerdfonts; do
  localfont=$(basename $nerdfont | sed -e "s/%20/-/g")
  if [ ! -e $HOME/.local/share/fonts/$localfont ]; then
    echo "Installing font $localfont"
    curl -fLo $HOME/.local/share/fonts/$localfont --create-dirs \
      https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/$nerdfont
  fi
done

fc-cache -vf $HOME/.local/share/fonts


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
