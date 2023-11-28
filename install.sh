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

# Function to show a popup notification
# show_notification() {
#     osascript -e 'display notification "All selected applications have been installed." with title "Installation Complete"'
# }

# Function to install a package
install_package() {
    echo "Installing $1..."
    brew install $1
}

# Check for Homebrew installation
check_homebrew

echo "Select applications to install (press ENTER after your selections):"

# Function to check if an application is already installed
is_installed() {
    if type "$1" > /dev/null 2>&1; then
        echo "$1 is already installed."
        return 0 # Return 0 indicates the app is installed
    else
        return 1 # Return 1 indicates the app is not installed
    fi
}

# Function to install a package
install_package() {
    if ! is_installed "$1"; then
        echo "Installing $1..."
        brew install $1 | tee /dev/tty
    else
        echo "Skipping installation of $1 as it is already installed."
    fi
}

# Function to update Homebrew
update_homebrew() {
    echo "Updating Homebrew..."
    brew update
}

# Function to upgrade all installed packages
upgrade_packages() {
    echo "Upgrading all installed packages..."
    brew upgrade
}

# Define the options
options=("update" "upgrade" "git" "node" "python" "firefox" "vlc" "done")

# Generate the menu
PS3='Please enter your choice: '
select opt in "${options[@]}"
do
    if [ "$opt" == "done" ]; then
        break
    elif [[ " ${options[@]} " =~ " ${opt} " ]]; then
        install_package "$opt"
    elif [ "$opt" == "update" ]; then
        update_homebrew
    elif [ "$opt" == "upgrade" ]; then
        upgrade_packages
    else
        echo "Invalid option $REPLY"
    fi
done
# Exiting
echo "Exiting MacUtil..."
sleep 3
echo "Done."
# # After the installation process
# echo "All applications have been installed."
# show_notification