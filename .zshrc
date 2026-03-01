# =============================================================================
# Zinit Plugin Manager Setup
# =============================================================================

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Auto-install zinit if not present
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# =============================================================================
# OMZ Libraries (load synchronously for core functionality)
# =============================================================================

zinit snippet OMZL::git.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZL::directories.zsh

# =============================================================================
# Plugins via Turbo Mode (deferred loading for faster startup)
# =============================================================================

# Developer Tools
zinit wait lucid for \
  OMZP::git \
  OMZP::terraform \
  OMZP::vault

# Container Management
zinit wait lucid for \
  OMZP::docker \
  OMZP::kops

# Python
zinit wait lucid for \
  OMZP::pip

# Node.js
zinit wait lucid for \
  OMZP::nvm

# OS-specific plugins
if [[ "$OSTYPE" = darwin* ]]; then
  # Fix for multi-file OMZ plugins (GitHub dropped SVN support)
  # Uses git sparse-checkout to fetch all plugin files
  _fix-omz-plugin() {
    [[ -f ./._zinit/teleid ]] || return 1
    local teleid="$(<./._zinit/teleid)"
    local pluginid
    for pluginid (${teleid#OMZ::plugins/} ${teleid#OMZP::}) {
      [[ $pluginid != $teleid ]] && break
    }
    (($?)) && return 1
    git clone --quiet --no-checkout --depth=1 --filter=tree:0 \
      https://github.com/ohmyzsh/ohmyzsh
    cd ./ohmyzsh
    git sparse-checkout set --no-cone /plugins/$pluginid
    git checkout --quiet
    cd ..
    for file (./ohmyzsh/plugins/$pluginid/*(D)) {
      [[ $file == *.gitignore || $file == *.plugin.zsh ]] && continue
      cp -R $file ./${file:t}
    }
    rm -rf ./ohmyzsh
  }
  zinit ice atpull"%atclone" atclone"_fix-omz-plugin"
  zinit snippet OMZP::macos
elif [[ "$OSTYPE" = linux* ]]; then
  zinit wait lucid for OMZP::ubuntu
fi

# Misc
zinit wait lucid for OMZP::command-not-found

# Community plugins (loaded in order: completions, autosuggestions, then syntax-highlighting)
zinit wait lucid for \
  atload"zicompinit; zicdreplay" \
  blockf \
  zsh-users/zsh-completions

zinit wait lucid for \
  atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions

zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
  zsh-users/zsh-syntax-highlighting

# =============================================================================
# Starship Prompt
# =============================================================================

eval "$(starship init zsh)"

# =============================================================================
# Source Secrets (tokens, keys - never committed)
# =============================================================================

[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"

# =============================================================================
# Environment Variables
# =============================================================================

export DOTNET_ROOT="$HOME/dotnet"
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"

# =============================================================================
# PATH Configuration
# =============================================================================

# Homebrew (ensure it's first)
if [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# dotnet
export PATH="$PATH:$HOME/dotnet"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# libpq (Postgres)
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/libpq/lib"
export CPPFLAGS="-I/usr/local/opt/libpq/include"

# Uv (Python)
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Maestro
export PATH="$PATH:$HOME/.maestro/bin"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Android SDK (for Flutter)
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"

# Flutter via FVM
export PATH="$HOME/fvm/default/bin:$PATH"

# =============================================================================
# Tool Initialization
# =============================================================================

# NVM (Node Version Manager)
export NVM_DIR="$HOME/dotfiles/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Google Cloud SDK
if [ -f "$HOME/dotfiles/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/dotfiles/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/dotfiles/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/dotfiles/google-cloud-sdk/completion.zsh.inc"
fi

# GVM (Go Version Manager)
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Conda
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
    . "/opt/anaconda3/etc/profile.d/conda.sh"
  else
    export PATH="/opt/anaconda3/bin:$PATH"
  fi
fi
unset __conda_setup

# Dart CLI Completion
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh" || true

# =============================================================================
# Aliases
# =============================================================================

alias am='cd "$HOME/Workspace/sear/mcp_agent_mail" && scripts/run_server_with_token.sh'
