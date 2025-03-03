source $HOME/dotfiles/antigen.zsh

antigen use oh-my-zsh

# Developer Enhancements
antigen bundle git
antigen bundle heroku
antigen bundle redis-cli
antigen bundle terraform
antigen bundle vault

# Container Managment
antigen bundle docker
# antigen bundle kubectl
antigen bundle kops

# Python
antigen bundle pip

# Node.js
antigen bundle nvm
antigen bundle yarn
antigen bundle react-native

# OS
if  [[ "$OSTYPE" = darwin* ]]; then
  antigen bundle macos
elif [[ "$OSTYPE" = linux* ]]; then
  antigen bundle ubuntu # If I'm using my dotfiles on a gnux distro, chances are it's ubuntu
fi

# Misc
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

antigen theme tylerreckart/hyperzsh

antigen apply

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/dotfiles/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/dotfiles/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/dotfiles/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/dotfiles/google-cloud-sdk/completion.zsh.inc"; fi

export NVM_DIR="$HOME/dotfiles/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/anoshmalik/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export DOTNET_ROOT=$HOME/dotnet
export PATH=$PATH:$HOME/dotnet

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
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
# <<< conda initialize <<<

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/libpq/lib"
export CPPFLAGS="-I/usr/local/opt/libpq/include"
