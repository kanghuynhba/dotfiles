# ============================================================================
# Heavy Packages - Prompted before install
# ============================================================================
# These packages are large and optional. User will be asked for each one.
# ============================================================================

install_openjdk() {
    local os="$1"
    echo "    → Installing openjdk..."
    
    if [[ "$os" == "macos" ]]; then
        brew install temurin
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install -y openjdk-21-jdk
    fi
    
    echo "    ✓ openjdk installed"
}

install_maven() {
    local os="$1"
    echo "    → Installing maven..."
    
    if [[ "$os" == "macos" ]]; then
        brew install maven
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install -y maven
    fi
    
    echo "    ✓ maven installed"
}

install_postgresql() {
    local os="$1"
    echo "    → Installing postgresql..."
    
    if [[ "$os" == "macos" ]]; then
        brew install postgresql@15
        brew services start postgresql@15
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install -y postgresql postgresql-contrib
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
    fi
    
    echo "    ✓ postgresql installed"
}

install_mariadb() {
    local os="$1"
    echo "    → Installing mariadb..."
    
    if [[ "$os" == "macos" ]]; then
        brew install mariadb
        brew services start mariadb
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install -y mariadb-server mariadb-client
        sudo systemctl start mariadb
        sudo systemctl enable mariadb
    fi
    
    echo "    ✓ mariadb installed"
}

install_redis() {
    local os="$1"
    echo "    → Installing redis..."
    
    if [[ "$os" == "macos" ]]; then
        brew install redis
        brew services start redis
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install -y redis-server
        sudo systemctl start redis-server
        sudo systemctl enable redis-server
    fi
    
    echo "    ✓ redis installed"
}

install_gcloud() {
    local os="$1"
    echo "    → Installing Google Cloud CLI..."
    
    if [[ "$os" == "macos" ]]; then
        brew install --cask google-cloud-sdk
    elif [[ "$os" == "ubuntu" ]]; then
        # Install gcloud CLI
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk-main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
        sudo apt-get update -qq
        sudo apt-get install -y google-cloud-cli
    fi
    
    echo "    ✓ gcloud-cli installed"
    echo "    → Run 'gcloud init' to configure"
}

install_azure() {
    local os="$1"
    echo "    → Installing Azure CLI..."
    
    if [[ "$os" == "macos" ]]; then
        brew install azure-cli
    elif [[ "$os" == "ubuntu" ]]; then
        curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
        echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
        sudo apt-get update -qq
        sudo apt-get install -y azure-cli
    fi
    
    echo "    ✓ azure-cli installed"
    echo "    → Run 'az login' to authenticate"
}

install_gcc() {
    local os="$1"
    echo "    → Installing GCC..."
    
    if [[ "$os" == "macos" ]]; then
        brew install gcc
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install -y gcc g++ gdb
    fi
    
    echo "    ✓ gcc installed"
}

install_llvm() {
    local os="$1"
    echo "    → Installing LLVM/Clang..."
    
    if [[ "$os" == "macos" ]]; then
        brew install llvm
    elif [[ "$os" == "ubuntu" ]]; then
        # Add LLVM repository
        wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
        echo "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-17 main" | sudo tee /etc/apt/sources.list.d/llvm.list
        sudo apt-get update -qq
        sudo apt-get install -y clang-17 lldb-17 lld-17
        sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-17 100
        sudo update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-17 100
    fi
    
    echo "    ✓ llvm installed"
}
