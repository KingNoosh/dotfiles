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
antigen bundle kubectl
antigen bundle kops

# Python
antigen bundle pip

# Node.js
antigen bundle nvm
antigen bundle yarn
antigen bundle react-native

# OS
antigen bundle osx

# Misc
antigen bundle command-not-found

# ZSH Users
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
