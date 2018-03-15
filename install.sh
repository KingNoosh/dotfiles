#!/usr/bin/env bash

# Symlink General Files
ln -sf ~/dotfiles/.zshrc ~/.zshrc

# MacOS Specific Tasks
if  [[ "$OSTYPE" = darwin* ]]; then
  # Symlink MacOS Files
  ln -sf ~/dotfiles/.Brewfile ~/.Brewfile

  # Install Homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew bundle --global
elif [[ "$OSTYPE" = linux* ]]; then
  sudo apt-get install -y zsh
  chsh -s $(which zsh)
fi

# Install NVM
export NVM_DIR="$HOME/dotfiles/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
) && \. "$NVM_DIR/nvm.sh"

# Install Antigen
curl -L git.io/antigen > $HOME/dotfiles/antigen.zsh

# Install GCP SDK
curl "https://dl.google.com/dl/cloudsdk/channels/rapid/install_google_cloud_sdk.bash" | bash -s -- --disable-prompts --install-dir="$HOME/dotfiles/google-cloud-sdk"

exec -l /usr/local/bin/zsh
