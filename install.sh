#!/bin/bash

echo "███╗░░░███╗░█████╗░░█████╗░██╗░░░██╗████████╗██╗██╗░░░░░  ██╗░░░██╗░░███╗░░░░░░█████╗░░░░░█████╗░"
echo "████╗░████║██╔══██╗██╔══██╗██║░░░██║╚══██╔══╝██║██║░░░░░  ██║░░░██║░████║░░░░░██╔══██╗░░░██╔══██╗"
echo "██╔████╔██║███████║██║░░╚═╝██║░░░██║░░░██║░░░██║██║░░░░░  ╚██╗░██╔╝██╔██║░░░░░██║░░██║░░░██║░░██║"
echo "██║╚██╔╝██║██╔══██║██║░░██╗██║░░░██║░░░██║░░░██║██║░░░░░  ░╚████╔╝░╚═╝██║░░░░░██║░░██║░░░██║░░██║"
echo "██║░╚═╝░██║██║░░██║╚█████╔╝╚██████╔╝░░░██║░░░██║███████╗  ░░╚██╔╝░░███████╗██╗╚█████╔╝██╗╚█████╔╝"
echo "╚═╝░░░░░╚═╝╚═╝░░╚═╝░╚════╝░░╚═════╝░░░░╚═╝░░░╚═╝╚══════╝  ░░░╚═╝░░░╚══════╝╚═╝░╚════╝░╚═╝░╚════╝░"

echo "Press ENTER to continue. If you don't have Homebrew installed, please press ENTER to install it."
read -p ""

# Function to check if Homebrew is installed
check_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi
}

# Function to install a package
install_package() {
    echo "Installing $1..."
    brew install $1
}

# Check for Homebrew installation
check_homebrew

echo "Select applications to install:"

# Define the options
options=(
    "git" "Install Git"
    "node" "Install Node.js"
    "python" "Install Python"
    "firefox" "Install Firefox"
    "vlc" "Install VLC Media Player"
    # Add more applications here
)

# Generate the menu
PS3='Please enter your choice: '
select opt in "${options[@]}"
do
    case $opt in
        "Install Git")
            install_package "git"
            ;;
        "Install Node.js")
            install_package "node"
            ;;
        "Install Python")
            install_package "python"
            ;;
        "Install Firefox")
            install_package "firefox"
            ;;
        "Install VLC Media Player")
            install_package "vlc"
            ;;
        # Add more cases here for additional applications
        *)
            echo "Invalid option $REPLY";;
    esac
done