# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Added by Aaron Podell

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# TODO: split up mac and linux portions

# NOTE: always clone the dotfiles repo into $HOME/dotfiles
alias brc="vim ~/dotfiles/.bashrc"

# some env variables
export EDITOR="vim"
export DOT="~/dotfiles/"

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

alias g="git"
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias grc="git rebase --continue"
alias gca="git commit -am "
alias gpoh="git push origin HEAD"
alias gpfoh="git push --force origin HEAD"
alias gpum="git pull upstream master"


# cpp laziness
alias mcb="make clean && make build"
alias delobj="find . -type f -name '*.[d,o]' -delete;"



git_changed_files() {
    #git diff --name-only $1 $(git merge-base $1 upstream/master)
    local branch_name=$(git symbolic-ref --short -q HEAD)
    git diff --name-only $branch_name $(git merge-base $branch_name upstream/master) # this would do from last pr
    #git diff --name-only $branch_name $(git merge-base $branch_name origin/$branch_name) # this would do from remot  e
}

_git_changed_files() {
    IFS=$'\n' tmp=( $(compgen -W "$(git branch)" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}

#complete -d -o default -F _git_changed_files big

# complete but local only 
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

# fix weird wrappings
alias fix_wrap="kill -WINCH $$"
fix_wrap

# change colors for ls
#export LS_COLORS='di='${COLOR_CYAN_di} #  for linux
export LSCOLORS=gxfxcxdxCxegedabagacad  # fg/bg - dir sym socket pipe ex block char ex ex dir dir
#alias ls="ls --color=auto"  # this breaks on mac for some reason

# source bash_completion script
# [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"



#python stuff
#make python interpreter work again. tied to .pythonrc
#export PYTHONSTARTUP=$HOME/.pythonrc
#dont write .pyc files
export PYTHONDONTWRITEBYTECODE=1

#history control
export HISTCONTROL=ignoredups
shopt -s histverify

shopt -s cdspell # let me spell poorly
#shopt -s globstar # for use with jd function # this doesnt work on mac/iterm



# colorize output unless piping to a file. dont look at object binaries
# THIS MAGICALLY BREAKS THINGS ON MAC! DON'T UNCOMMENT UNTIL FURTHER RESEARCH
#export GREP_OPTIONS='--color=auto --exclude=\*.o --exclude=\*.depends --exclude=\*.d --include=\*.fsm --include=\*.f --include=\*.c --include=\*.cpp --include=\*.py --include=\*.h --include=\*q --include=\*tmpl --include=\*yaml -nr'
#export GREP_OPTIONS='--color=auto --exclude=\*\.o --exclude-dir=\.git --exclude=tags -nr' # not this one
#alias sgrep="GREP_OPTIONS= grep"

######################
######## GIT #########
######################
gfr() {
    git fetch $1 $2;
    git rebase $1/$2;
}

######################
###### UTILITY #######
######################
mkcd() {
    mkdir -p "$*"
    cd "$*"
}

sed_all() {
    find ./ -type f -not -path './.git/*' -exec sed -i -e 's/'$1'/'$2'/g' {} \;
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


# ------ GIT ------ #
# old script for getting git completion
#source ~/.git-completion.sh

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
    tmux # attach || tmux
fi

