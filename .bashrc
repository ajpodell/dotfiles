# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Added by Aaron Podell

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

#some basics
alias rless="less -r"
alias vim="vim -p"
alias vi="vim -p"

# git & other laziness
alias g="git"
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias grc="git rebase --continue"
alias gca="git commit -am "
alias gpoh="git push origin HEAD"
alias gpfoh="git push --force origin HEAD"
alias gpum="git pull upstream master"
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

complete -d -o default -F _git_changed_files big

alias fix_wrap="kill -WINCH $$"
fix_wrap

# change dark blue to lighter blue in ls
#export LS_COLORS='di='${COLOR_CYAN_di}
export LS_COLORS='di='${COLOR_CYAN2}
alias ls="ls --color=auto"

set -o vi # vim in bash
#make python interpreter work again. tied to .pythonrc
export PYTHONSTARTUP=$HOME/.pythonrc

#history control
export HISTCONTROL=ignoredups
shopt -s histverify

shopt -s cdspell # let me spell poorly
shopt -s globstar # for use with jd function


#dont write .pyc files
export PYTHONDONTWRITEBYTECODE=1

# colorize output unless piping to a file
export GREP_OPTIONS='--color=auto --exclude=\*.o --exclude=\*.depends --exclude=\*.d --include=\*.fsm --include=\*.f
 --include=\*.c --include=\*.cpp --include=\*.py --include=\*.h --include=\*q --include=\*tmpl --include=\*yaml -nr'
#export GREP_OPTIONS='--color=auto --exclude=\*\.o --exclude-dir=\.git --exclude=tags -nr'
alias sgrep="GREP_OPTIONS= grep"

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
    find ./ -type f -not -path "./.git/*" -exec sed -i -e 's/'$1'/'$2'/g' {} \;
}

######################
##### NAVIGATION #####
######################
up()
{
    if [ -z "$1" ]; then
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



# BASH PROMPT
source ~/.git-completion.sh
# last 3 dirs of pwd
pwdtail() {
    pwd | awk -F/ '{print "../"$(NF-2)"/"$(NF-1)"/"$NF}' | sed 's/ /\//g' | sed 's/.*home\//\/home\//' | sed 's/.*\/  ts\//\/ts\//' | sed 's/.*bb\//\/bb\//'
}


# i think this was testing setting the title bar, but i broke it
case $TERM in
    xterm*)
        PS1="\[\033]0;\u@\h: \w\$(__git_ps1)\007\]bash\\$ "
        ;;
    *)
        #PS1=${COLOR_GREEN}'\u@\h '${COLOR_RED}'$(__git_ps1 "(%s)")'${COLOR_YELLOW}'\a'${COLOR_RESET}"\n\$ ";
        #;;
esac

COLOR_RED='\[\e[31m\]'
COLOR_RED2='\e[31m'
COLOR_GREEN='\[\e[0;32m\]'
COLOR_GREEN2='\e[0;32m'
COLOR_YELLOW='\[\e[0;33m\]'
COLOR_YELLOW2='\e[0;33m'
COLOR_BLUE='\[\e[1;34m\]'
COLOR_PURPLE='\[\e[0;35m\]'
COLOR_CYAN='\[\e[0;36m\]'
COLOR_CYAN_di='\[\e[0;36'
COLOR_CYAN2='0;36'
COLOR_RESET='\[\e[0m\]'
COLOR_RESET2='\e[0m'

# this requires the git-completion.sh script
function prompt {
    PS1='$ '
    echo -e ${COLOR_GREEN2}${USER}'@'${HOSTNAME}${COLOR_RED2}`__git_ps1`${COLOR_YELLOW2}' '`pwdtail`'\a'${COLOR_RESE
T2}
}
PROMPT_COMMAND='prompt'


# DISABLE BELL
set bell-style none
#xset -b


# RUN TMUX AT STARTUP
if [[ ! $TERM =~ screen-256color ]]; then
    tmux attach || tmux
fi

