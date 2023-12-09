#!/bin/bash

# echo "███╗░░░███╗░█████╗░░█████╗░██╗░░░██╗████████╗██╗██╗░░░░░  ██╗░░░██╗░░███╗░░░░░░█████╗░░░░░█████╗░"
# echo "████╗░████║██╔══██╗██╔══██╗██║░░░██║╚══██╔══╝██║██║░░░░░  ██║░░░██║░████║░░░░░██╔══██╗░░░██╔══██╗"
# echo "██╔████╔██║███████║██║░░╚═╝██║░░░██║░░░██║░░░██║██║░░░░░  ╚██╗░██╔╝██╔██║░░░░░██║░░██║░░░██║░░██║"
# echo "██║╚██╔╝██║██╔══██║██║░░██╗██║░░░██║░░░██║░░░██║██║░░░░░  ░╚████╔╝░╚═╝██║░░░░░██║░░██║░░░██║░░██║"
# echo "██║░╚═╝░██║██║░░██║╚█████╔╝╚██████╔╝░░░██║░░░██║███████╗  ░░╚██╔╝░░███████╗██╗╚█████╔╝██╗╚█████╔╝"
# echo "╚═╝░░░░░╚═╝╚═╝░░╚═╝░╚════╝░░╚═════╝░░░░╚═╝░░░╚═╝╚══════╝  ░░░╚═╝░░░╚══════╝╚═╝░╚════╝░╚═╝░╚════╝░"

echo "Press ENTER to continue."
read -p ""
echo "If you don't have Homebrew installed, please press ENTER to install it."
echo -p ""

# Read applications from JSON file
read_applications_from_json() {
    if [ -f "applications.json" ]; then
        mapfile -t applications < <(jq -r '.applications[]' applications.json)
        options+=("${applications[@]}")
    else
        echo "Warning: applications.json not found."
    fi
}

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
show_notification() {
    osascript -e 'display notification "All selected applications have been installed." with title "Installation Complete"'
}

# Function to install a package
install_package() {
    local app_name="$1"
    echo "Installing $app_name..."
    brew install "$app_name" | tee /dev/tty
}

# Check for Homebrew installation
check_homebrew

# Read applications from JSON file
read_applications_from_json

# Display checkboxes for application selection
show_checkbox_menu() {
    local menu_options=()
    for app in "${options[@]}"; do
        menu_options+=("$app" "off")
    done

    selected_apps=$(whiptail --title "Select applications to install" --checklist \
        "Use spacebar to select applications:" 20 60 10 "${menu_options[@]}" 3>&1 1>&2 2>&3)

    if [ $? -eq 0 ]; then
        selected_apps=($selected_apps)
    else
        echo "Selection canceled. Exiting."
        exit 0
    fi
}

# Function to check if an application is already installed
is_installed() {
    local app_name="$1"
    if type "$app_name" > /dev/null 2>&1; then
        echo "$app_name is already installed."
        return 0 # Return 0 indicates the app is installed
    else
        return 1 # Return 1 indicates the app is not installed
    fi
}

# Function to install selected applications
install_selected_apps() {
    for selected_app in "${selected_apps[@]}"; do
        install_package "$selected_app"
    done
}

# Function to update Homebrew
update_homebrew() {
    echo "Updating Homebrew..."
    brew update | pv -l | tee /dev/tty
}

# Function to upgrade all installed packages
upgrade_packages() {
    echo "Upgrading all installed packages..."
    brew upgrade | pv -l | tee /dev/tty
}

# Generate the menu
PS3='Please enter your choice: '
options+=("custom" "done") # Add "custom" option
select opt in "${options[@]}"
do
    if [ "$opt" == "done" ]; then
        break
    elif [ "$opt" == "custom" ]; then
        custom_installation
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

# List successfully installed applications after installation completes
list_installed_apps

# Exiting
echo "Exiting MacUtil..."
sleep 3
echo "Done."
# After the installation process
show_notification