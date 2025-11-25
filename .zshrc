# source the shared items
# echo "zshrc running"
source "$DOTPATH/.shared_rc"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# vim keybindings
bindkey -v
bindkey 'jj' vi-cmd-mode
# export KEYTIMEOUT=10 # move to visual mode more quickly

# Various configs
# history - make history shared and a bund of no duplicates
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space # protect sensitive info
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# aliases
# colorize ls
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
alias ls='ls --color'

# fzf - needs to be installed already to get this to work
eval "$(fzf --zsh)"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept


bindkey '^E' end-of-line


# plugins (todo: source these in a nother file)
# predicated on zinit, above
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

plugins=(git vi-mode)

# come back to this - basically tab on everything, but you'll want to change the
# key for "accept suggestion for autosuggestions"
zinit light Aloxaf/fzf-tab

autoload -U compinit && compinit

# spaceship
# SPACESHIP_HOST_SHOW="always"

# start starship prompt
# MOVE THE STARSHIP CONFIG away from
# ~/.config/starship.toml
# and into your dotfiles!!
export STARSHIP_CONFIG=$DOTPATH/starship.toml
eval "$(starship init zsh)"


# set pyenv and map python to python3
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# this stops the second print of the virtualenv in its own line above the prompt
eval "$(pyenv init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv virtualenv-init -)" # If using pyenv-virtualenv

# setting up autoenv
# will need to do a check for this one
if [ -f /opt/homebrew/opt/autoenv/activate.sh ]; then
    # echo "starting autoenv"
    # this can be a little dangerous since were not validating our .env files, but i think i'm ok with it
    export AUTOENV_ASSUME_YES=true
    export AUTOENV_ENABLE_LEAVE=yes
    export AUTOENV_VIEWER=cat
    export AUTOENV_ENV_FILENAME=".env.autoenv"

    # these are test items to see if they work with cursor - it is suggesting that these not being set are the culprits of the missing test commands
    export AUTOENV_AUTH_FILE="$HOME/.autoenv_authorized"
    export AUTOENV_NOTAUTH_FILE="$HOME/.autoenv_notauthorized"

    # this is provided by autoenv
    source /opt/homebrew/opt/autoenv/activate.sh
fi
