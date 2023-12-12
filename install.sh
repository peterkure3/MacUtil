#!/bin/bash

echo "███╗░░░███╗░█████╗░░█████╗░██╗░░░██╗████████╗██╗██╗░░░░░  ██╗░░░██╗░░███╗░░░░░░█████╗░░░░░█████╗░"
echo "████╗░████║██╔══██╗██╔══██╗██║░░░██║╚══██╔══╝██║██║░░░░░  ██║░░░██║░████║░░░░░██╔══██╗░░░██╔══██╗"
echo "██╔████╔██║███████║██║░░╚═╝██║░░░██║░░░██║░░░██║██║░░░░░  ╚██╗░██╔╝██╔██║░░░░░██║░░██║░░░██║░░██║"
echo "██║╚██╔╝██║██╔══██║██║░░██╗██║░░░██║░░░██║░░░██║██║░░░░░  ░╚████╔╝░╚═╝██║░░░░░██║░░██║░░░██║░░██║"
echo "██║░╚═╝░██║██║░░██║╚█████╔╝╚██████╔╝░░░██║░░░██║███████╗  ░░╚██╔╝░░███████╗██╗╚█████╔╝██╗╚█████╔╝"
echo "╚═╝░░░░░╚═╝╚═╝░░╚═╝░╚════╝░░╚═════╝░░░░╚═╝░░░╚═╝╚══════╝  ░░░╚═╝░░░╚══════╝╚═╝░╚════╝░╚═╝░╚════╝░"

echo "Press ENTER to continue."
read -p ""
echo "If you don't have Homebrew installed, please press ENTER to install it."
echo -p ""

# Path to the applications JSON file
JSON_FILE="applications.json"

# Function to check if Homebrew is installed
check_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
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

# Function to install a package
install_package() {
    local app_name="$1"
    if ! is_installed "$app_name"; then
        echo "Installing $app_name..."
        brew install "$app_name" | tee /dev/tty
    else
        echo "Skipping installation of $app_name as it is already installed."
    fi
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

# Function to read applications from JSON file
read_categories_from_json() {
    if [ -f "$JSON_FILE" ]; then
        # Read categories from the "categories" array in the JSON file
        categories=($(jq -r 'keys_unsorted[]' "$JSON_FILE"))
    else
        zenity --error --title="Error" \
            --text="Error: $JSON_FILE not found." \
            --width=400 --height=200
        exit 1
    fi
}

# Function to read applications for a specific category from JSON file
read_apps_by_category() {
    local category="$1"
    if [ -f "$JSON_FILE" ]; then
        # Read apps for the specified category
        apps=($(jq -r ".categories[\"$category\"][]" "$JSON_FILE"))
    else
        zenity --error --title="Error" \
            --text="Error: $JSON_FILE not found." \
            --width=400 --height=200
        exit 1
    fi
}

# Check for Homebrew installation
check_homebrew

# Generate the menu
PS3='Please enter your choice: '


select category in "Developer" "Media" "Miscellaneous" "Office" "System" "Update Homebrew" "Upgrade Packages" "Done"
do
    case $category in
        "Update Homebrew")
            update_homebrew
            ;;
        "Upgrade Packages")
            upgrade_packages
            ;;
        "Done")
            break
            ;;
        *)  
            
            # Read applications for the selected category
            read_apps_by_category "$category"

            # Display list with check boxes for app selection
            selected_apps=$(zenity --list --title="MacUtil" \
                --text="Choose the apps you want to install:" \
                --checklist \
                --column="Select" \
                --column="App" \
                $(for app in "${apps[@]}"; do
                    echo FALSE "$app"
                done) \
                --width=400 --height=300 \
                --separator="|" \
                --ok-label="Install" --extra-button="Back")

            if [ $? -eq 0 ]; then
                # Install selected applications one by one
                for selected_app in $(echo "$selected_apps" | tr "|" "\n"); do
                    install_package "$selected_app"
                done

                # Display final dialog after all installations are done
                zenity --info --title="Installation Done" \
                    --text="All selected applications have been installed." \
                    --width=400 --height=200 \
                    --ok-label="Done"
            fi
            ;;
    esac
done

# Exiting
echo "Exiting MacUtil..."
sleep 1
echo "Done."
