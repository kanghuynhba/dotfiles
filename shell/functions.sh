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
	echo Running $# cpp files which is: "$@"

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
    if [ -f sentry.properties ]; then
        echo "🔗 Running with Sentry agent..."
        if [ -z "$1" ]; then
            SENTRY_PROPERTIES_FILE=demo/sentry.properties \
            mvn clean compile exec:java \
                -Dexec.args="-javaagent:sentry-opentelemetry-agent-8.21.1.jar"
        else
            SENTRY_PROPERTIES_FILE=demo/sentry.properties \
            mvn clean compile exec:java -Dexec.mainClass="$1" \
                -Dexec.args="-javaagent:sentry-opentelemetry-agent-8.21.1.jar"
        fi
    else
        echo "⚡ Running without Sentry..."
        if [ -z "$1" ]; then
            mvn clean compile exec:java
        else
            mvn clean compile exec:java -Dexec.mainClass="$1"
        fi
    fi
}

javaExe() {
    echo "Executing programs at $(date)"
    echo "Running $# java files which is: $@"

    for file in "$@"; do
        echo "--- Output of $file ---"
        
        # Extract the Class Name (remove .java extension)
        # We need the pure name (e.g., "Main") to run the java command
        className=$(echo "$file" | sed 's/\.java//g')
        
        if [ ! -d "./execution" ]; then
            mkdir execution
        fi

        # Compile: -d specifies the destination directory for the .class file
        javac -d "./execution" "$file"
        
        # Execute: -cp sets the classpath to the execution directory
        java -cp "./execution" "$className"
    done
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
