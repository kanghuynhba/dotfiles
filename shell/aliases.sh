set -o vi

# ls alias 
alias ll="ls -la"

# tldr alias
alias forex="tldr"

# xdg-open alias
alias xdg-open="xdg-open >/dev/null 2>&1"

# Go up [n] directories
up()
{
    local cdir="$(pwd)"
    if [[ "${1}" == "" ]]; then
        cdir="$(dirname "${cdir}")"
    elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a number"
    elif ! [[ "${1}" -gt "0" ]]; then
        echo "Error: argument must be positive"
    else
        for ((i=0; i<${1}; i++)); do
            local ncdir="$(dirname "${cdir}")"
            if [[ "${cdir}" == "${ncdir}" ]]; then
                break
            else
                cdir="${ncdir}"
            fi
        done
    fi
    cd "${cdir}"
}

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# cd alias
projectPath=~/Workspace/projects
alias tools="cd ~/tools"
alias tools="cd ~/tools"
alias pyProject="cd $projectPath/py-projects/"
alias cppProject="cd $projectPath/cpp-projects/"
alias vimPlugins="cd ~/.vim/pack/vendor/start"

# vim alias
shellPath=~/dotfiles/shell
alias aliasConfig="vim $shellPath/aliases.sh"
alias funcConfig="vim $shellPath/functions.sh"

# venv alias
alias icloud="source ~/venv/icloud/bin/activate"

eval "$(gh copilot alias -- bash)"

# activate env and cd to that directoy
leetcode() {
    source ~/venv/leetcode/bin/activate 
    cd $projectPath/leetcode/src 
    ls -t
}

cs229() {
    xdg-open ~/Documents/note/Main\ Open\ Course/cs229-2018-autumn/syllabus-autumn2018
    xdg-open https://www.bilibili.com/video/BV1JE411w7Ub/?spm_id_from=333.1387.collection.video_card.click&vd_source=83a430eab3c17ad059d382af7fc9db2e
    source ~/venv/cs229/bin/activate
    pyProject
    cd cs229/
}

# open google
google() {
	local query=$(echo $@ | sed 's/ /+/g') 
	xdg-open https://www.google.com/search?q=$query 
}

listCourses() {
	xdg-open https://space.bilibili.com/400647031/lists/389026?type=series
}

# Update dotfiles
dfu() {
    (
        cd ~/.dotfiles && git pull --ff-only && bash ./install -q
    )
}

# Create a directory and cd into it
mcd() {
    mkdir "${1}" && cd "${1}"
}

# Jump to directory containing file
jump() {
    cd "$(dirname ${1})"
}

# Mirror a website
alias mirrorsite='wget -m -k -K -E -e robots=off'

