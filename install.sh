#!/usr/bin/env bash

set -e

echo "=== Dotfiles Installation ==="

# Symlink General Files
echo "Symlinking .zshrc..."
ln -sf ~/dotfiles/.zshrc ~/.zshrc

# MacOS Specific Tasks
if [[ "$OSTYPE" = darwin* ]]; then
  echo "Detected macOS..."

  # Symlink MacOS Files
  ln -sf ~/dotfiles/.Brewfile ~/.Brewfile

  # Symlink Starship config
  mkdir -p ~/.config
  ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml

  # Install Homebrew if not present
  if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Install packages via Brewfile
  echo "Installing Homebrew packages..."
  brew bundle --global

elif [[ "$OSTYPE" = linux* ]]; then
  echo "Detected Linux..."

  sudo apt-get update
  sudo apt-get install -y zsh curl git

  # Install Starship
  if ! command -v starship &> /dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh
  fi

  # Symlink Starship config
  mkdir -p ~/.config
  ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml

  # Set zsh as default shell
  chsh -s $(which zsh)
fi

# Install Zinit (auto-installed by .zshrc, but we can prime it)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  echo "Installing Zinit..."
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Install NVM
export NVM_DIR="$HOME/dotfiles/.nvm"
if [[ ! -d "$NVM_DIR" ]]; then
  echo "Installing NVM..."
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" origin)
  cd -
fi

# Install GCP SDK (optional - only if directory doesn't exist)
GCP_DIR="$HOME/dotfiles/google-cloud-sdk"
if [[ ! -d "$GCP_DIR" ]]; then
  echo "Installing Google Cloud SDK..."
  curl "https://sdk.cloud.google.com" | bash -s -- --disable-prompts --install-dir="$HOME/dotfiles"
fi

# Create secrets file template if it doesn't exist
if [[ ! -f "$HOME/.secrets" ]]; then
  echo "Creating ~/.secrets template..."
  cat > "$HOME/.secrets" << 'EOF'
# Secrets file - never commit this
# Add your tokens and API keys here

# Example:
# export CI_JOB_TOKEN="your-token-here"
# export GITHUB_TOKEN="your-github-token"
EOF
  chmod 600 "$HOME/.secrets"
  echo "Created ~/.secrets - add your tokens there"
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "IMPORTANT: If you had a GitLab token in your .zshrc, you need to:"
echo "  1. Revoke the old token in GitLab → Settings → Access Tokens"
echo "  2. Generate a new token"
echo "  3. Add it to ~/.secrets: export CI_JOB_TOKEN=\"your-new-token\""
echo ""
echo "Run 'exec zsh' or open a new terminal to apply changes."
