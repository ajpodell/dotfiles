# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Added by Aaron Podell
# SETUP #
# 1. clone into your home directory.
# 2. add the following line to your bashrc
# source $HOME/dotfiles/.bashrc

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# export DOTPATH="/Users/$(whoami)/dotfiles"
# export DOTPATH="/home/$(whoami)/dotfiles"
export DOTPATH=$HOME/dotfiles
export INPUTRC=$DOTPATH/.inputrc
alias dot="cd $DOTPATH"

# Load specific files for mac or linux
case "$(uname -s)" in
   Darwin)
  	 if [ -f $DOTPATH/.bash_mac ]; then
		source $DOTPATH/.bash_mac
	 fi
     ;;
   Linux)
  	 if [ -f $DOTPATH/.bash_linux ]; then
		source $DOTPATH/.bash_linux
	 fi
     ;;
   CYGWIN*|MINGW32*|MSYS*)
     echo 'why are you on windows?'
     ;;
   # Add here more strings to compare
   # See correspondence table at the bottom of this answer
   *)
     echo 'Other OS' 
     ;;
esac



# NOTE: always clone the dotfiles repo into $HOME/dotfiles
alias brc="vim ~/dotfiles/.bashrc"

# some env variables
export EDITOR="nvim"

#some basics
alias rless="less -r"
alias vim="nvim -p"
alias vi="nvim -p"

# this doesnt work, or really make sense
#alias vi="vim -p -c 'execute \"normal \".get(g:,\"mapleader\",\"\\\").\"f\"'"


alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias "....."="cd ../../../.."

#vim in bash for mac
set -o vi

##################################################################
############################## GIT ###############################
##################################################################
alias g="git"
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias gd="git diff"
alias grc="git rebase --continue"
alias gca="git commit -am "
alias gpoh="git push origin HEAD"
alias gpfoh="git push --force origin HEAD"
alias gpum="git pull upstream master"
alias gpom="git pull origin master"
alias gdom="git diff origin/master"
alias gco='git checkout'
alias gc='git checkout `FZF_DEFAULT_COMMAND="git branch" fzf`'
# bring autocomplete to g alias
complete -o bashdefault -o default -o nospace -F _fzf_path_completion g



# add the git scripts to path
export PATH=$PATH:$DOTPATH/git_scripts

gfr() {
    git fetch $1 $2;
    git rebase $1/$2;
}
# Source bash_completion script. Make sure to run "brew install bash-completion@2" on new machines
# TODO: need to modify this for machines which dont have brew
if command -v brew &> /dev/null
then
    if [ -f $(brew --prefix)/etc/bash_completion  ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

git_changed_files() {
    #git diff --name-only $1 $(git merge-base $1 upstream/master)
    local branch_name=$(git symbolic-ref --short -q HEAD)
    git diff --name-only $branch_name $(git merge-base $branch_name origin/master) # this would do from last pr
    #git diff --name-only $branch_name $(git merge-base $branch_name origin/$branch_name) # this would do from remote
}

_git_changed_files() {
    IFS=$'\n' tmp=( $(compgen -W "$(git branch)" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}


# this requires the git-completion.sh script
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function git_root() {
    git rev-parse --show-toplevel
}

optimize_git() {
    # Set to use fsmonitor and watchman instead of using raw stat calls
    # config current git project
    # git config core.fsmonitor fsmonitor-watchman
    # or globally for all git projects
    git config --global core.fsmonitor fsmonitor-watchman

    # or if you decided to not use this, you can unset the config
    # git config --unset core.fsmonitor
    # git config --global --unset core.fsmonitor

    # download the script
    curl https://raw.githubusercontent.com/git/git/master/templates/hooks--fsmonitor-watchman.sample -o /usr/local/bin/fsmonitor-watchman
    # make it executable
    chmod +x /usr/local/bin/fsmonitor-watchman
    # may need to `brew install watchman` at this point if that doesnt work

    # config current git project
    # git config core.untrackedCache true
    # or globally for all git projects
    git config --global core.untrackedCache true

    # or if you decided to not use this, you can unset the config
    # git config --unset core.untrackedCache
    # git config --global core.untrackedCache false
}


##################################################################
############################ END GIT #############################
##################################################################

# cpp laziness
alias mcb="make clean && make build"
alias delobj="find . -type f -name '*.[d,o]' -delete;"


# fix weirdness in bash
alias fix_wrap="kill -WINCH $$"  # this will kill the weird line breaks that happens sometimes
# fix_wrap

stty sane  # intended to fix the screen no longer showing typed chars




#python stuff
#make python interpreter work again. tied to .pythonrc
#export PYTHONSTARTUP=$HOME/.pythonrc
#dont write .pyc files
export PYTHONDONTWRITEBYTECODE=1

#history control
export HISTCONTROL=ignoredups

shopt -s histverify # not sure
shopt -s cdspell # let me spell poorly
shopt -s direxpand  # dont escape vars during tab completion
shopt -s histappend



# colorize output unless piping to a file. dont look at object binaries
# the line numbers mess up fzf history search. disable for now
#export GREP_OPTIONS='--color=auto --exclude=\*\.o --exclude-dir=""/Users/apodell/data/.git" --exclude-dir="/Users/apodell/data/tags" -nr' # not this one
alias grep='grep --color=auto --binary-file=without-match --exclude-dir=\.pants\.d --exclude="*.snap" --exclude-dir="dist"'

grep_with_without() {
    if (( $# != 3 )); then
        echo "Usage: grep_with_without string_to_match string_to_exclude directory" 
        return 1;
    fi

    # shellcheck disable=SC2046 
    grep -Lr "$2" $(grep -lr "$1" "$3")
}

#export GREP_OPTIONS='--color=auto --binary-file=without-match --exclude-dir=\.pants\.d --exclude="*.snap"' # not this one
#export GREP_OPTIONS+='"--exclude-dir="dist" --exclude="*snap"'
#alias sgrep="GREP_OPTIONS= grep"


######################
###### UTILITY #######
######################
mkcd() {
    mkdir -p "$*"
    cd "$*"
}

# TODO: conditionally accept a filetype and pass to the find command as * or *.[$filetype]
sed_all() {
    # for mac, sed needs a backup file, for linux, it needs the -e i think? 
    echo $1
    echo $2
    # add LANG so it doesnt blow up with utf-8 re issues
    # if you need pipes - change the sed command to have a different delimiter
    LANG=C find ./ -type f -name "*.jsx" -not -path './.git/*' -exec sed -i '' 's|'$1'|'$2'|g' {} \;
}

######################
##### NAVIGATION #####
######################
up()
{
    if [ -z "$1" ]; then
        echo "specify parent directory"
        return
    fi
    local upto=$1
    cd "${PWD/\/$upto\/*//$upto}"
}

_up()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    local d=${PWD//\//\ }
    COMPREPLY=( $( compgen -W "$d" -- "$cur" ) )
}
complete -F _up up


jd(){
    if [ -z "$1" ]; then
        echo "Usage: jd [directory]";
        return 1
    else
        #local restore_globstar=$(shopt -p globstar)
        #shopt -s globstar
        cd **"/$@"

        #$restore_globstar
    fi
}

newest(){
    if (( $# == 0 )); then
        echo "usage: open_newest [taskname] [dirname]"
    fi
    local task=$1
    local dirname=""
    if (( $# > 1 )); then
        dirname="$2/"
    fi
    echo $#
    echo $dirname
    less $(ls -t $dirname$task* | head -n 1)
}

# watch_make, from Eric
find_src() { # find test files?
    find . -name "gtest" -prune -o -name "Makefile" -o -name "*.h" -o -name "*.cc" -o -name '*.cpp'  -o -name "*.pro
to" -o -name "CMakeLists.txt" -o -name '*.yaml'
}

watch_make() {
    while [[ "$?" -ne "130" ]]; do \
        echo "starting..." ;
        find_src | entr -d -s "make $1 ;
        printf \"${iterm2_mark}done.....\"" ; done
}


# source fzf and add some fun hotkeys
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
fvi() {
    # data repo should be defined as the root of where you will want to live
    #root=$(git_root)
    #echo ${root}
    vi $(find . ${DATA_REPO} -not -path ".pants*" | fzf --multi --cycle --height=40%)
    #vi $(find . ${DATA_REPO} -not -path ".pants*" | fzf-tmux --multi --cycle)
}
# bind ctrl-f to fvi
bind '"\C-f":"fvi"'


# last 3 dirs of pwd
#pwdtail() {
#    pwd | awk -F/ '{print "../"$(NF-2)"/"$(NF-1)"/"$NF}' | sed 's/ /\//g' | sed 's/.*home\//\/home\//' | sed 's/.*\/  ts\//\/ts\//' | sed 's/.*bb\//\/bb\//'
#}


# i think this was testing setting the title bar, but i broke it
#case $TERM in
#    xterm*)
#        PS1="\[\033]0;\u@\h: \w\$(__git_ps1)\007\]bash\\$ "
#        ;;
#    *)
#        #PS1=${COLOR_GREEN}'\u@\h '${COLOR_RED}'$(__git_ps1 "(%s)")'${COLOR_YELLOW}'\a'${COLOR_RESET}"\n\$ ";
#        #;;
#esac

export CLICOLOR=1 #ansi colors in iterm2

COLOR_RED='\[\e[31m\]'
COLOR_RED2='\e[31m'
COLOR_RED_MAC='\033[0;31m'
COLOR_GREEN='\[\e[0;32m\]'
COLOR_GREEN2='\e[0;32m'
COLOR_GREEN_MAC='\033[0;32m'
COLOR_YELLOW='\[\e[0;33m\]'
COLOR_YELLOW2='\e[0;33m'
COLOR_YELLOW_MAC='\033[0;33m'
COLOR_BLUE='\[\e[1;34m\]'
COLOR_BLUE_MAC='\033[1;34m'
COLOR_PURPLE='\[\e[0;35m\]'
COLOR_CYAN='\[\e[0;36m\]'
COLOR_CYAN_di='\[\e[0;36'
COLOR_CYAN_MAC='\[\e[36;0m\]'
COLOR_CYAN_MAC_di='\e[0;36m'
COLOR_CYAN2='0;36'
COLOR_RESET='\[\e[0m\]'
COLOR_RESET2='\e[0m'
COLOR_RESET_MAC='\033[0;00m'


 # Determine active Python virtualenv details.
function set_virtualenv () {
    if test -z "$VIRTUAL_ENV" ; then
        PYTHON_VIRTUALENV=""
    else
        PYTHON_VIRTUALENV="${COLOR_BLUE_MAC}(`basename \"$VIRTUAL_ENV\"`)${COLOR_RESET_MAC}"
    fi
}

function prompt {
    # set python_virtualenv
    set_virtualenv 

    PS1='$ '
    echo -e "${PYTHON_VIRTUALENV} ${COLOR_GREEN_MAC}${USER}@${HOSTNAME}${COLOR_RED_MAC}$(parse_git_branch) ${COLOR_YELLOW_MAC}${PWD}\a${COLOR_RESET_MAC}"
    #echo -e ${COLOR_GREEN2}${USER}'@'${HOSTNAME}${COLOR_RED2}`__git_ps1`${COLOR_YELLOW2}' '`pwdtail`'\a'${COLOR_RESET2}
}
PROMPT_COMMAND='prompt'


# straight up this is taken from online and i dont really get it, but has worked for me in the past
# https://gist.github.com/tevino/1a557a0c200d61d4e4fb
fix_virtualenv() {
	ENV_PATH="$(dirname "$(dirname "$(which pip)")")"
	SYSTEM_VIRTUALENV="$(which -a virtualenv|tail -1)"

	BAD_ENV_PATHS="/usr/local"

	echo "Ensure the root of the broken virtualenv:"
	echo "    $ENV_PATH"

	if [[ -z "$ENV_PATH" ]] || [[ "$ENV_PATH" = *"$BAD_ENV_PATHS"* ]]; then
		echo "The root path above doesn't seems to be a valid one."
		echo "Please make sure you ACTIVATED the broken virtualenv."
		echo "‼️  Exiting for your safety... (thanks @laymonk for reporting this)"
		exit 1
	fi

	read -p "‼️  Press Enter if you are not sure (y/N) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "♻️  Removing old symbolic links......"
		find "$ENV_PATH" -type l -delete -print
		echo "💫  Creating new symbolic links......"
		$SYSTEM_VIRTUALENV "$ENV_PATH"
		echo "🎉  Done!"
	fi
}

##################################################################
############################## TMUX###############################
##################################################################
# RUN TMUX AT STARTUP
# but only if were on a system where tmux is supported
if command -v tmux &> /dev/null
then
    if [[ ! $TERM =~ screen-256color ]]; then
        tmux attach || tmux
    fi
fi

do_layout() {
    tmux split-window -h -p 33
    # now in the right window, split it vertically. (50% is default)
    tmux split-window -v -p 50

    tmux select-pane -t 0
    tmux split-window -h -p 50 vim

}


