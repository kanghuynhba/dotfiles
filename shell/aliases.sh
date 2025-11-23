set -o vi

# ls alias 
# --- Modern LS Replacement (eza) ---
# --icons: shows file type icons
# --group-directories-first: folders always at top
# --git: shows git status (dirty/clean) next to file
alias ls='eza --group-directories-first'
alias ll='eza --group-directories-first -la --git'
alias tree='eza --tree '
# shutdown alias
alias shutdown="systemctl poweroff"

# tldr alias
alias forex="tldr"

# open alias
alias open="xdg-open >/dev/null 2>&1"

# connect gdrive
gdrive() {
      # Check if the mount point directory exists
      if [ ! -d "$HOME/gdrive" ]; then
        echo "Creating mount point: ~/gdrive"
        mkdir -p "$HOME/gdrive"
      fi

      echo "Attempting to mount gdrive: to ~/gdrive..."
      # Run in background with nohup, but log errors to a file
      nohup rclone mount gdrive: ~/gdrive --vfs-cache-mode writes > ~/gdrive_mount.log 2>&1 &
      
      # Give it a second to try and mount
      sleep 2
      
      # Check if the mount was successful
      if mountpoint -q "$HOME/gdrive"; then
        echo "✅ GDrive mounted successfully."
      else
        echo "❌ Mount failed. Check logs at ~/gdrive_mount.log"
      fi
    }

    # Function to unmount
    ungdrive() {
      echo "Attempting to unmount ~/gdrive..."
      fusermount -u ~/gdrive
      if [ $? -eq 0 ]; then
        echo "✅ GDrive unmounted successfully."
      else
        echo "❌ Unmount failed. Is it already unmounted?"
      fi
}

# Go up [n] directories
up() {
    local count=$1
    # Default to 1 if no argument
    [[ -z $count ]] && count=1
    
    # Verify input is a number
    if ! [[ $count =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a number"
        return 1
    fi

    # Construct the path (../ repeated n times)
    local d=""
    for ((i=0; i<count; i++)); do
        d="../$d"
      done
    
    cd $d
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
alias test="cd ~/Workspace/tests"
alias dotnetProject="cd $projectPath/dotnet-projects/"
alias cppProject="cd $projectPath/cpp-projects/"
alias vimPlugins="cd ~/.vim/pack/vendor/start"

rustProject() {
    cd "$projectPath/rust-projects/"
    tmuxInit "$1" 
}

javaProject() {
    cd "$projectPath/java-projects/"
    tmuxInit "$1" 
}

pyProject() {
    cd $projectPath/py-projects/
    tmuxInit "$1"
}
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
# eval "$(gh copilot alias -- bash)"

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
    tmux new -d -s "write $1"
    tmux new -d -s "exec $1" 
    tmux new -d -s "git $1" 
    tmux new -d -s "sample $1" 
    tmux a -t "write $1"
}

# activate env and cd to that directoy
leetcode() {
    open https://leetcode.com/problemset/
    cd $projectPath/leetcode/src 
    tmuxInit "leetcode"
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
	local query=$(echo "$*" | sed 's/ /+/g') 
    # 3. IMPORTANT: Quotes required around URL in Zsh because of '?'d"
    open "https://www.google.com/search?q=$query"
}

# open github
github() {
    open "https://github.com/kanghuynhba?tab=repositories"
}

listCourses() {
	open "https://space.bilibili.com/400647031/lists/389026?type=series"
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

# Detect OS and set copy alias
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    alias copy='pbcopy'
    alias paste='pbpaste'
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # WSL (Windows Subsystem for Linux)
    alias copy='clip.exe'
    # No easy paste for WSL CLI
else
    # Linux (assuming X11)
    alias copy='xclip -selection clipboard'
    alias paste='xclip -selection clipboard -o'
fi
