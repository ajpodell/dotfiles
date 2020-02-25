# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Added by Aaron Podell

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
export DOTPATH="/Users/$(whoami)/dotfiles"
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
export EDITOR="vim"

#some basics
alias rless="less -r"
alias vim="vim -p"
alias vi="vim -p"

alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias "....."="cd ../../../.."

#vim in bash for mac
set -o vi
#bindkey -v
#bindkey -M viins md-mode


# laziness + git laziness
alias c="cd"
alias l="ls"

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
alias gco="git checkout"

# add the git scripts to path
export PATH=$PATH:$DOTPATH/git_scripts

gfr() {
    git fetch $1 $2;
    git rebase $1/$2;
}
# Source bash_completion script. Make sure to run "brew install bash-completion@2" on new machines
if [ -f $(brew --prefix)/etc/bash_completion  ]; then
    . $(brew --prefix)/etc/bash_completion
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



#complete -d -o default -F _git_changed_files big

# complete but local only  -- this isnt really needed with autocomplete fixed, set up an alias
#gco() {
#    git checkout $1
#}
#
#_gco()
#{
#    local cur=${COMP_WORDS[COMP_CWORD]}
#    local branches=$(git branch)
#    #COMPREPLY=( $( compgen -W "$cur") )
#    #local d=${PWD//\//\ }
#    COMPREPLY=( $( compgen -W "$branches" -- "$cur" ) )
#}
#complete -F _gco gco
##################################################################
############################ END GIT #############################
##################################################################

# cpp laziness
alias mcb="make clean && make build"
alias delobj="find . -type f -name '*.[d,o]' -delete;"


# fix weird wrappings
alias fix_wrap="kill -WINCH $$"
fix_wrap




#python stuff
#make python interpreter work again. tied to .pythonrc
#export PYTHONSTARTUP=$HOME/.pythonrc
#dont write .pyc files
export PYTHONDONTWRITEBYTECODE=1

#history control
export HISTCONTROL=ignoredups
shopt -s histverify

shopt -s cdspell # let me spell poorly



# colorize output unless piping to a file. dont look at object binaries
# the line numbers mess up fzf history search. disable for now
#export GREP_OPTIONS='--color=auto --exclude=\*\.o --exclude-dir=""/Users/apodell/data/.git" --exclude-dir="/Users/apodell/data/tags" -nr' # not this one
export GREP_OPTIONS='--color=auto --binary-file=without-match --exclude-dir=\.pants\.d' # not this one
#alias sgrep="GREP_OPTIONS= grep"


######################
###### UTILITY #######
######################
mkcd() {
    mkdir -p "$*"
    cd "$*"
}

sed_all() {
    # for mac, sed needs a backup file, for linux, it needs the -e i think? 
    find ./ -type f -not -path './.git/*' -exec sed -i '' 's/'$1'/'$2'/g' {} \;
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
    #vi $(find . $(git_root) -not -path ".pants*" | fzf-tmux --multi --cycle)
    vi $(find . ${DATA_REPO} -not -path ".pants*" | fzf-tmux --multi --cycle)
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



# this requires the git-completion.sh script
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function git_root() {
    git rev-parse --show-toplevel
}

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


# DISABLE BELL
#set bell-style none 
#xset -b # this one doesnt really work. not sure where its from


# RUN TMUX AT STARTUP
if [[ ! $TERM =~ screen-256color ]]; then
    tmux attach || tmux
fi

