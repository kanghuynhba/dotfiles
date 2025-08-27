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
        if [ ! -d "./execution" ]; then
            mkdir execution
        fi
		g++ "$file" -o "./execution/"$exeFile""
		./execution/"$exeFile"
	done
}

mvnExe() {
    mvn exec:java -Dexec.mainClass=$@
}

javaExe() {
    javac $1
    if [ $? -eq 0 ]; then 
        echo "Compilation successful. Searching for main methods..."
        for file in "$@"; do
            if grep -q "public static void main" "$file"; then
                classname=$(echo "$file" | sed 's#^./##; s#/#.#g; s#.java$##')
                echo "Running $classname..."
                java -cp . "$classname"
                
            fi
        done
    else 
        echo "Compilation failed. Check for errors."
    fi
}

mvunzip() {
    mv ${1} ${2} 
    filename=$(basename "${1}")
    cd ${2}
    unzip -o ${filename}
    rm ${filename}
    rm ${1}
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
