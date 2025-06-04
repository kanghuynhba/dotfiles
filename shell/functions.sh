path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

cppExe() {
	echo "Executing programs at $(date)"
	echo "Running $# cpp files which is: $@"

	for file in "$@"; do
		echo "Output of $file"
		exeFile=$(echo "$file" | sed 's/.cpp/.exe/g')
		g++ "$file" -o "./execution/"$exeFile""
		./execution/"$exeFile"
	done
}

# Open Google
google() {
	local query=$(echo $@ | sed 's/ /+/g') 
	xdg-open https://www.google.com/search?q=$query 
}

listCourses() {
	xdg-open https://space.bilibili.com/400647031/lists/389026?type=series
}

rmSwp() {
	find . -name '*.swp' -exec rm {} \;
	find . -name '*.swm' -exec rm {} \;
	find . -name '*.swn' -exec rm {} \;
	find . -name '*.swo' -exec rm {} \;
	find . -name '*~' -exec rm {} \;
}

here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink $HOME/.shell.here)"
}

there="$HOME/.shell.here"

there() {
    cd "$(readlink "${there}")"
}
