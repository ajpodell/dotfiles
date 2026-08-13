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
# esc+v to open command in editor
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
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

# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(starship init zsh)"
    # eval "$(/usr/local/bin/starship init zsh)"
  }

# replaced by above, which prevents repeated reloads causing an error
# eval "$(starship init zsh)"


# trying out "uv" starting 2026-04-13. safe to delete if not coming back to pyenv
# set pyenv and map python to python3
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# # this stops the second print of the virtualenv in its own line above the prompt
# eval "$(pyenv init -)"
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# eval "$(pyenv virtualenv-init -)" # If using pyenv-virtualenv
# use ipdb in python
export PYTHONBREAKPOINT=ipdb.set_trace

# always source the bookkeeping venv on shell start
# may switch to direnv if this becomes problematic
if [ -f "$HOME/bookkeeping/.venv/bin/activate" ]; then
    source "$HOME/bookkeeping/.venv/bin/activate"
fi

# setting up autoenv
# will need to do a check for this one
if [ -f /opt/homebrew/opt/autoenv/activate.sh ]; then
    # if [[ -o interactive ]] && [[ -t 0 ]]; then
    # echo "starting autoenv" >&2
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
    # fi
fi

# Disable autoenv when there is no TTY attached
if [[ ! -t 0 ]]; then
  typeset -f cd >/dev/null 2>&1 && unset -f cd
fi

# openssl can be a pain. claude is usually pretty good, but sometimes you need to export LDFLAGS & CPPFLAGS.
# this is probably better not checked in since it can move, but the last time i exported it looked like this
# export LDFLAGS="-L/opt/homebrew/opt/openssl/lib -L/opt/homebrew/opt/libpq/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/openssl/include -I/opt/homebrew/opt/libpq/include"
# new as of july 13 after upgrade
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/opt/libpq/include"


# Claude Code
# someone on reddit thinks this may fix the scrolling behavior with tmux
# https://www.reddit.com/r/ClaudeCode/comments/1sxmg52/scrolling_inside_tmux_broken_recently/
CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1



# ALTERNATE TO ABOVE
# --- autoenv setup ---
# source /path/to/autoenv/activate.sh
# ---------------------

# Disable autoenv in Cursor
# if [[ "${TERM_PROGRAM:-}" == "cursor" || "${TERM_PROGRAM:-}" == "Cursor" ]]; then
#   typeset -f cd >/dev/null 2>&1 && unset -f cd
# fi
