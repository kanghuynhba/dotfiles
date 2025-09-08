set -o vi

# ls alias 
alias ll="ls -la"

# shutdown alias
alias shutdown="systemctl poweroff"

# tldr alias
alias forex="tldr"

# open alias
alias open="xdg-open >/dev/null 2>&1"

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
alias dotnetProject="cd $projectPath/dotnet-projects/"
alias cppProject="cd $projectPath/cpp-projects/"
alias javaProject="cd $projectPath/java-projects/"
alias vimPlugins="cd ~/.vim/pack/vendor/start"

# vim alias
shellPath=~/dotfiles/shell
alias aliasConfig="vim $shellPath/aliases.sh"
alias funcConfig="vim $shellPath/functions.sh"
alias coursesConfig="vim $shellPath/courses.sh"

# mysql alias
alias mysql="mysql --default-character-set=utf8mb4 -u root -p"

# venv alias
alias icloud="source ~/venv/icloud/bin/activate"

#gdb - debugger for low level file
alias gdb="pwndbg-lldb"

# writegood
alias writegood="write-good"

# Copilot terminal alias ( ghce, ghcs )
eval "$(gh copilot alias -- bash)"

# maven init
mvnInit() {
    mvn archetype:generate -DgroupId=com.hbk.$1 -DartifactId=$1 -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
}

# open an azure's server
server() {
    echo "Connecting to $3 ..."
    az vm $1 --resource-group "$2" --name "$3"    
}

# tmux init
tmuxInit() {
    tmux new -d -s "write"
    tmux new -d -s "exec" 
    tmux new -d -s "git" 
    tmux a -t "write"
}

# activate env and cd to that directoy
leetcode() {
    source ~/venv/leetcode/bin/activate 
    if [[ "$1" == "-w" ]]; then
        open https://leetcode.com/problemset/
        return
    fi
    cd $projectPath/leetcode/src 
    ls -t
}

# open eclipse
eclipse() {
    javaProject
    cd eclipse
    ./eclipse
}

# open google
google() {
	local query=$(echo $@ | sed 's/ /+/g') 
	open https://www.google.com/search?q=$query 
}

# open github
github() {
    open https://github.com/kanghuynhba?tab=repositories
}

listCourses() {
	open https://space.bilibili.com/400647031/lists/389026?type=series
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

