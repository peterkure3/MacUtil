#!/bin/bash

# Function to install a package
install_package() {
    echo "Installing $1..."
    brew install $1
}

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
