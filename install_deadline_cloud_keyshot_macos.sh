#!/bin/bash
# Resize terminal window
printf '\e[8;40;100t'

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                   STARK - Scripted Tool for AWS Rendering Kickoff                                                                               #
#                                                                   AWS Deadline Cloud for KeyShot - macOS Setup Script                                                                           #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

# Script                | install_deadline_cloud_keyshot_macos.sh
# Version               | 1.1x
# Author                | Jonathan Albarran
# Email                 | dev@jonathanalbarran.com
# Website               | https://jonathanalbarran.com/

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                          Color Scheme                                                                                           #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

RESET='\033[0m'
BOLD='\033[1m'
BG_COLOR='\033[48;5;235m'
TEXT_COLOR='\033[38;5;252m'
COMMENT='\033[38;5;65m'
KEYWORD='\033[38;5;75m'
STRING='\033[38;5;179m'
VARIABLE='\033[38;5;43m'
FUNCTION='\033[38;5;176m'
ERROR='\033[38;5;196m'
SUCCESS='\033[38;5;150m'
WARNING='\033[38;5;179m'

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                        Initial Checks                                                                                           #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

# Function to display the success header
header() {
    echo -e "${BG_COLOR}${SUCCESS}#########################################################################${RESET}\n"
}

# Function to display the error header
header_error() {
    echo -e "${BG_COLOR}${ERROR}#########################################################################${RESET}\n"
}

# Exit script if not using bash.
if [ -z "$BASH_VERSION" ]; then
    script_name=$(basename "$0")
    osascript -e 'tell application "Terminal" to clear'
    printf '%b' "${BG_COLOR}${ERROR}#########################################################################${RESET}\n"
    printf '%b' "\n${TEXT_COLOR}#${RESET} The script requires to be run with bash, run the command printed below...\n"
    printf "${TEXT_COLOR}#${RESET} ${KEYWORD}bash${RESET} ${STRING}%s${RESET} ${VARIABLE}%s${RESET}\n\n" "${script_name}" "$*"
    exit 1
fi

# Check if the operating system is macOS
if [[ "$(uname)" != "Darwin" ]]; then
  header_error
  echo -e "${WARNING}#${RESET} This script is designed to run exclusively on macOS."
  echo -e "${WARNING}#${RESET} Exiting..."
  exit 1
fi

# Function to abort script execution and display error message
abort() {

    # Display error header
    echo -e "\n\n${BG_COLOR}${ERROR}#########################################################################${RESET}\n"

    # Display error messages and contact information
    echo -e "${BOLD}${TEXT_COLOR}#${RESET} An error occurred. Aborting script..."
    echo -e "${BOLD}${TEXT_COLOR}#${RESET} Please contact Jonathan Albarran."
    echo -e "${BOLD}${TEXT_COLOR}#${RESET} Visit: ${KEYWORD}'https://github.com/JonathanAlbarran/deadline-cloud-for-keyshot-macos/'${RESET}\n"
    exit 1
}

# Function to display the script logo
script_logo() {
  cat << "EOF"

 .d8888b. 88888888888     d8888 8888888b.  888    d8P        8888888b.   .d8888b.  
d88P  Y88b    888        d88888 888   Y88b 888   d8P         888  "Y88b d88P  Y88b 
Y88b.         888       d88P888 888    888 888  d8P          888    888 888    888 
 "Y888b.      888      d88P 888 888   d88P 888d88K           888    888 888        
    "Y88b.    888     d88P  888 8888888P"  8888888b          888    888 888        
      "888    888    d88P   888 888 T88b   888  Y88b  888888 888    888 888    888 
Y88b  d88P    888   d8888888888 888  T88b  888   Y88b        888  .d88P Y88b  d88P 
 "Y8888P"     888  d88P     888 888   T88b 888    Y88b       8888888P"   "Y8888P"  
  
                                                                                 
EOF
}

# Function to start the script execution
start_script() {
  # Get the location of the script
  script_location="${BASH_SOURCE[0]}"
  
  # Check if the script is running from a file
  if ! [[ -f "${script_location}" ]]; then 
    header_error
    echo -e "${ERROR}#${RESET} Heads up: This script needs to be saved to disk to run properly."
    echo -e "${ERROR}#${RESET} Follow the instructions below to download and execute it correctly:\n"
    echo -e "${KEYWORD}curl -sO https://raw.githubusercontent.com/JonathanAlbarran/deadline-cloud-for-keyshot-macos/main/install_deadline_cloud_keyshot_macos.sh && bash install_deadline_cloud_keyshot_macos.sh${RESET}\n"
    exit 1
  fi

  # Extract the script name from the file
  script_name="$(grep -i "# Script" "${script_location}" | head -n 1 | cut -d'|' -f2 | sed -e 's/^ //g')"
  
  # Display the header and logo
  header
  script_logo
  
  # Print initialization messages 
  echo -e "${SUCCESS}#${RESET} Initiating ${BOLD}${script_name}${RESET}..."
  echo -e "${SUCCESS}#${RESET} Let's get you set up. Thanks for choosing this script to streamline your setup.\n"
}

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                        Main Script                                                                                              #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

# Function to set up logging for the script
setup_logging() {
    local enable_logging=$1
    if [[ "$enable_logging" == "--log" ]]; then
        LOG_FILE=~/Documents/setup_deadline_keyshot.log
        exec > >(tee -i "$LOG_FILE")
        exec 2>&1
        echo -e "${KEYWORD}#${RESET} Logging enabled. Log file: ${VARIABLE}$LOG_FILE${RESET}"
    fi
}

# Function to detect KeyShot installations
detect_keyshot() {
    echo -e "${TEXT_COLOR}#${RESET} Calling ${FUNCTION}detect_keyshot${RESET} function..."

    KEYSHOT_VERSIONS=()
    KEYSHOT_PATHS=()

    # Function to extract version from plist
    extract_plist_version() {
        local plist_file="$1"
        local version=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$plist_file" 2>/dev/null)
        if [ -z "$version" ]; then
            version=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$plist_file" 2>/dev/null)
        fi
        echo "$version"
    }

    # Search for KeyShot.app and KeyShot<version>.app in /Applications
    while IFS= read -r app_path; do
        app_name=$(basename "$app_path")
        plist_file="$app_path/Contents/Info.plist"
        if [ -f "$plist_file" ]; then
            version=$(extract_plist_version "$plist_file")
            if [ -n "$version" ]; then
                KEYSHOT_VERSIONS+=("$version")
                KEYSHOT_PATHS+=("$app_path")
            fi
        fi
    done < <(find "/Applications" -maxdepth 1 -name "KeyShot*.app" -not -name "*Handler.app" -not -name "*Configurator.app" -not -name "*Monitor.app" -not -name "*Tray.app")

    if [ ${#KEYSHOT_VERSIONS[@]} -eq 0 ]; then
        echo -e "${ERROR}#${RESET} No KeyShot installation found. Please ensure KeyShot is installed correctly."
        abort
    elif [ ${#KEYSHOT_VERSIONS[@]} -eq 1 ]; then
        KEYSHOT_VERSION="${KEYSHOT_VERSIONS[0]}"
        KEYSHOT_PATH="${KEYSHOT_PATHS[0]}"
        echo -e "${SUCCESS}#${RESET} Detected KeyShot version: $KEYSHOT_VERSION"
        echo -e "${SUCCESS}#${RESET} KeyShot path: $KEYSHOT_PATH"
    else
        echo -e "${WARNING}#${RESET} Multiple KeyShot versions detected. Please choose one:"
        for i in "${!KEYSHOT_VERSIONS[@]}"; do
            echo "$((i+1)). ${KEYSHOT_VERSIONS[i]} (${KEYSHOT_PATHS[i]})"
        done
        while true; do
            echo -e -n "Enter your choice ${STRING}(1-${#KEYSHOT_VERSIONS[@]})${RESET}: "
            read -r choice
            if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#KEYSHOT_VERSIONS[@]}" ]; then
                index=$((choice-1))
                KEYSHOT_VERSION="${KEYSHOT_VERSIONS[index]}"
                KEYSHOT_PATH="${KEYSHOT_PATHS[index]}"
                echo -e "${SUCCESS}#${RESET} Selected KeyShot version: ${VARIABLE}$KEYSHOT_VERSION${RESET}"
                echo -e "${SUCCESS}#${RESET} KeyShot path: $KEYSHOT_PATH"
                break
            else
                echo -e "${ERROR}#${RESET} Invalid selection. Please try again."
            fi
        done
    fi

    # Extract major version number
    KEYSHOT_MAJOR_VERSION=$(echo "$KEYSHOT_VERSION" | cut -d. -f1)
    echo -e "${SUCCESS}#${RESET} KeyShot major version: $KEYSHOT_MAJOR_VERSION"

    # Construct the correct folder name
    if [[ "$KEYSHOT_MAJOR_VERSION" == "13" ]]; then
        KEYSHOT_FOLDER="KeyShot"
    else
        KEYSHOT_FOLDER="KeyShot$KEYSHOT_MAJOR_VERSION"
    fi
    echo -e "${SUCCESS}#${RESET} KeyShot folder name: $KEYSHOT_FOLDER"
}

# Function to check if KeyShot is running
is_keyshot_running() {
    if pgrep -f "[k]eyshot" > /dev/null || pgrep -f "KeyShot.*\.app" > /dev/null; then
        return 0  # KeyShot is running
    else
        return 1  # KeyShot is not running
    fi
}

# Function to handle user interaction for active KeyShot
check_keyshot_running() {
    while is_keyshot_running; do
        echo -e "${WARNING}#${RESET} KeyShot is currently running."
        echo -e "${BOLD}${TEXT_COLOR}#${RESET} Please choose an option:\n"
        
        echo -e "${KEYWORD}1.${RESET} ${TEXT_COLOR}I'll save my work and close KeyShot manually.${RESET}"
        echo -e "${KEYWORD}2.${RESET} ${WARNING}Force close KeyShot (may result in data loss).${RESET}"
        echo -e "${KEYWORD}3.${RESET} ${TEXT_COLOR}Exit the script. I'll run it again after closing KeyShot.${RESET}\n"
        
        echo -e -n "Enter your choice ${STRING}(1/2/3)${RESET}: "
        read -r choice
        
        case $choice in
            1)
                echo -e "${TEXT_COLOR}#${RESET} Please save your work and close KeyShot."
                echo -e "${TEXT_COLOR}#${RESET} Press any key once you've done this to continue..."
                read -r -n 1 -s
                if ! is_keyshot_running; then
                    echo -e "${SUCCESS}#${RESET} KeyShot has been closed. Continuing with the installation..."
                    return 2  # Signal that KeyShot was closed and script should be reinvoked
                else
                    echo -e "${WARNING}#${RESET} KeyShot is still running. Let's try again."
                fi
                ;;
            2)
                echo -e "${WARNING}#${RESET} Attempting to force close KeyShot..."
                if pkill -f "keyshot"; then
                    echo -e "${SUCCESS}#${RESET} KeyShot has been closed."
                    return 2  # Signal that KeyShot was closed and script should be reinvoked
                else
                    echo -e "${ERROR}#${RESET} Failed to close KeyShot. Please try again or close it manually."
                fi
                ;;
            3)
                echo -e "${TEXT_COLOR}#${RESET} Exiting script. Please run it again after closing KeyShot."
                exit 0
                ;;
            *)
                echo -e "${ERROR}#${RESET} Invalid choice. Please try again."
                ;;
        esac
    done

    echo -e "${SUCCESS}#${RESET} KeyShot is not running. Proceeding with installation."
    return 0
}

# Function to download and copy KeyShot Submitter script to the appropriate folder
copy_keyshot_script() {
    echo -e "${TEXT_COLOR}#${RESET} Calling ${FUNCTION}copy_keyshot_script${RESET} function..."
    KEYSHOT_SCRIPTS_DIR="/Library/Application Support/$KEYSHOT_FOLDER/Scripts/"

    # Check if the target directory exists and is writable
    echo -e "${WARNING}#${RESET} Checking target directory..."
    echo -e "${TEXT_COLOR}#${RESET} Target directory: $KEYSHOT_SCRIPTS_DIR"
    if [ -d "$KEYSHOT_SCRIPTS_DIR" ]; then
        echo -e "${SUCCESS}#${RESET} Target directory exists."
        if [ -w "$KEYSHOT_SCRIPTS_DIR" ]; then
            echo -e "${SUCCESS}#${RESET} Target directory is writable."
        else
            echo -e "${WARNING}#${RESET} Target directory is not writable. Attempting to create with sudo..."
            if ! sudo mkdir -p "$KEYSHOT_SCRIPTS_DIR"; then
                echo -e "${ERROR}#${RESET} Failed to create Scripts directory. Please check your permissions."
                abort
            fi
        fi
    else
        echo -e "${WARNING}#${RESET} Target directory does not exist. Attempting to create..."
        if ! sudo mkdir -p "$KEYSHOT_SCRIPTS_DIR"; then
            echo -e "${ERROR}#${RESET} Failed to create Scripts directory. Please check your permissions."
            abort
        fi
    fi

    SCRIPT_NAME="Submit to AWS Deadline Cloud.py"
    TARGET_FILE="$KEYSHOT_SCRIPTS_DIR/$SCRIPT_NAME"

    # Check if the script already exists and prompt for overwrite if it does
    if [ -f "$TARGET_FILE" ]; then
        echo -e "${WARNING}#${RESET} The script '${VARIABLE}$SCRIPT_NAME${RESET}' already exists in the Scripts directory."
        echo -e -n "Do you want to overwrite it? ${STRING}(y/n)${RESET} "
        read -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${TEXT_COLOR}#${RESET} Skipping script download. Using existing file."
            return
        fi
    fi

    echo -e "${TEXT_COLOR}#${RESET} Downloading KeyShot Submitter script..."
    
    # Download and copy the script
    if curl -sSL "https://raw.githubusercontent.com/aws-deadline/deadline-cloud-for-keyshot/release/keyshot_script/Submit%20to%20AWS%20Deadline%20Cloud.py" -o "$TARGET_FILE"; then
        echo -e "${SUCCESS}#${RESET} KeyShot Submitter script downloaded and copied successfully to ${VARIABLE}$KEYSHOT_SCRIPTS_DIR${RESET}"
        # Set appropriate permissions
        sudo chmod 644 "$TARGET_FILE"
    else
        echo -e "${ERROR}#${RESET} Failed to download or copy KeyShot Submitter script. Please check your internet connection and file permissions, then try again."
        abort
    fi

    # Verify the downloaded file
    if [ ! -s "$TARGET_FILE" ]; then
        echo -e "${ERROR}#${RESET} The downloaded file is empty. Please check your internet connection and try again."
        abort
    fi
}

# Function to install and verify Xcode Command Line Tools
install_xcode_cli_tools() {
    echo -e "${TEXT_COLOR}#${RESET} Calling ${FUNCTION}install_xcode_cli_tools${RESET} function..."
    
    if ! xcode-select -p &> /dev/null; then
        echo -e "${WARNING}#${RESET} Xcode Command Line Tools not found."
        echo -e "${TEXT_COLOR}#${RESET} Would you like to install Xcode Command Line Tools now?"
        echo -e -n "Enter ${STRING}(y/n)${RESET}: "
        read -r install_choice
        
        if [[ $install_choice =~ ^[Yy]$ ]]; then
            echo -e "${WARNING}#${RESET} Initiating Xcode Command Line Tools installation..."
            xcode-select --install
            echo -e "${TEXT_COLOR}#${RESET} Please complete the installation process when prompted."
            echo -e "${TEXT_COLOR}#${RESET} Press any key once the installation is complete..."
            read -n 1 -s
            
            if ! xcode-select -p &> /dev/null; then
                echo -e "${ERROR}#${RESET} Xcode Command Line Tools installation failed or was cancelled."
                echo -e "${TEXT_COLOR}#${RESET} Unable to proceed without Xcode Command Line Tools."
                abort
            else
                echo -e "${SUCCESS}#${RESET} Xcode Command Line Tools installed successfully."
            fi
        else
            echo -e "${ERROR}#${RESET} Xcode Command Line Tools are required to proceed."
            abort
        fi
    else
        echo -e "${SUCCESS}#${RESET} Xcode Command Line Tools are already installed."
    fi
}

# Function to create and activate virtual environment
create_and_activate_venv() {
    echo -e "${TEXT_COLOR}#${RESET} Calling ${FUNCTION}create_and_activate_venv${RESET} function..."
    VENV_DIR="$HOME/keyshot_deadline_venv"
    echo -e "${WARNING}#${RESET} Checking for virtual environment at ${VARIABLE}$VENV_DIR${RESET}..."
    
    if [ -d "$VENV_DIR" ]; then
        echo -e "${WARNING}#${RESET} Virtual environment directory already exists."
        echo -e -n "Do you want to use the existing environment? ${STRING}(y/n)${RESET}: "
        read -r use_existing

        if [[ $use_existing =~ ^[Yy]$ ]]; then
            echo -e "${SUCCESS}#${RESET} Using existing virtual environment."
            if source "$VENV_DIR/bin/activate" 2>/dev/null; then
                echo -e "${SUCCESS}#${RESET} Virtual environment activated."
                return 0
            else
                echo -e "${ERROR}#${RESET} Failed to activate existing virtual environment."
                echo -e "${WARNING}#${RESET} The existing directory might not be a valid virtual environment."
                echo -e -n "Do you want to delete it and create a new one? ${STRING}(y/n)${RESET}: "
                read -r recreate
                if [[ ! $recreate =~ ^[Yy]$ ]]; then
                    echo -e "${ERROR}#${RESET} Cannot proceed without a working virtual environment."
                    abort
                fi
            fi
        fi

        echo -e "${WARNING}#${RESET} Removing existing directory..."
        rm -rf "$VENV_DIR"
    fi

    echo -e "${WARNING}#${RESET} Creating a new virtual environment at ${VARIABLE}$VENV_DIR${RESET}..."
    if python3 -m venv "$VENV_DIR"; then
        source "$VENV_DIR/bin/activate"
        echo -e "${SUCCESS}#${RESET} New virtual environment created and activated."
    else
        echo -e "${ERROR}#${RESET} Failed to create virtual environment. Please check your Python installation."
        abort
    fi
}

# Function to set up environment variables
setup_environment_variables() {
    echo -e "${TEXT_COLOR}#${RESET} Calling ${FUNCTION}setup_environment_variables${RESET} function..."
    DEADLINE_PYTHON="$VENV_DIR/bin/python3"
    echo "export DEADLINE_PYTHON=\"$DEADLINE_PYTHON\"" >> ~/.zshrc

    PYTHON_SITE_PACKAGES=$("$DEADLINE_PYTHON" -c "import site; print(site.getsitepackages()[0])")
    DEADLINE_KEYSHOT="$PYTHON_SITE_PACKAGES/deadline/keyshot_submitter"
    echo "export DEADLINE_KEYSHOT=\"$DEADLINE_KEYSHOT\"" >> ~/.zshrc

    source ~/.zshrc

    echo -e "${KEYWORD}#${RESET} DEADLINE_PYTHON is set to: ${VARIABLE}$DEADLINE_PYTHON${RESET}"
    echo -e "${KEYWORD}#${RESET} DEADLINE_KEYSHOT is set to: ${VARIABLE}$DEADLINE_KEYSHOT${RESET}"

    # Verify the paths
    if [ ! -d "$DEADLINE_KEYSHOT" ]; then
        echo -e "${WARNING}#${RESET} DEADLINE_KEYSHOT directory not found. Attempting to locate it..."
        DEADLINE_KEYSHOT=$("$DEADLINE_PYTHON" -c "import deadline.keyshot_submitter as ks; print(ks.__file__.rsplit('/', 1)[0])")
        if [ -d "$DEADLINE_KEYSHOT" ]; then
            echo -e "${SUCCESS}#${RESET} DEADLINE_KEYSHOT found at: ${VARIABLE}$DEADLINE_KEYSHOT${RESET}"
            echo "export DEADLINE_KEYSHOT=\"$DEADLINE_KEYSHOT\"" >> ~/.zshrc
        else
            echo -e "${ERROR}#${RESET} Unable to locate DEADLINE_KEYSHOT. Please check your installation."
        fi
    fi

    create_keyshot_env_plist
}

# Function to create a plist file for KeyShot environment variables
create_keyshot_env_plist() {
    echo -e "${TEXT_COLOR}#${RESET} Calling ${FUNCTION}create_keyshot_env_plist${RESET} function..."
    local plist_dir="$HOME/Library/LaunchAgents"
    local plist_path="$plist_dir/com.keyshot.environment.plist"
    local keyshot_app="/Applications/$KEYSHOT_FOLDER.app"

    # Check if the LaunchAgents directory exists, create if it doesn't
    if [ ! -d "$plist_dir" ]; then
        echo -e "${WARNING}#${RESET} LaunchAgents directory does not exist. Creating..."
        if ! mkdir -p "$plist_dir"; then
            echo -e "${ERROR}#${RESET} Failed to create LaunchAgents directory. Please check your permissions."
            abort
        fi
    fi

    # Create the plist file
    echo -e "${WARNING}#${RESET} Creating plist file..."
    cat << EOF > "$plist_path"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.keyshot.environment</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/sh</string>
        <string>-c</string>
        <string>
        launchctl setenv DEADLINE_PYTHON "$DEADLINE_PYTHON"
        launchctl setenv DEADLINE_KEYSHOT "$DEADLINE_KEYSHOT"
        </string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF

    # Check if the file was created successfully
    if [ ! -f "$plist_path" ]; then
        echo -e "${ERROR}#${RESET} Failed to create plist file. Please check your permissions."
        abort
    fi

    # Set appropriate permissions for the plist file
    chmod 644 "$plist_path"

    # Unload the plist if it's already loaded
    launchctl unload "$plist_path" 2>/dev/null

    # Load the plist file
    if launchctl load "$plist_path"; then
        echo -e "${SUCCESS}#${RESET} LaunchCtl plist created and loaded at ${VARIABLE}$plist_path${RESET}"
    else
        echo -e "${WARNING}#${RESET} Failed to load LaunchCtl plist. You may need to restart your computer for the changes to take effect."
        echo -e "${WARNING}#${RESET} Alternatively, you can try running ${KEYWORD}'launchctl load $plist_path'${RESET} manually after the script finishes."
    fi
}

# Function to install required Python packages
install_required_packages() {
    echo -e "${TEXT_COLOR}#${RESET} Calling ${FUNCTION}install_required_packages${RESET} function..."
    echo -e "${WARNING}#${RESET} Installing deadline-cloud-for-keyshot, deadline[gui] packages..."
    if ! "$VENV_DIR/bin/pip" install deadline-cloud-for-keyshot==0.1.3 'deadline[gui]'; then
        echo -e "${ERROR}#${RESET} Error: Package installation failed!"
        abort
    fi
    echo -e "${SUCCESS}#${RESET} Packages installed successfully."
}

# Function to launch KeyShot
launch_keyshot() {
    echo -e "${TEXT_COLOR}#${RESET} Calling ${FUNCTION}launch_keyshot${RESET} function..."
    echo -e "${WARNING}#${RESET} Preparing to launch KeyShot..."
    KEYSHOT_APP="/Applications/$KEYSHOT_FOLDER.app"
    if [ ! -d "$KEYSHOT_APP" ]; then
        echo -e "${ERROR}#${RESET} Error: KeyShot application not found at ${VARIABLE}$KEYSHOT_APP${RESET}!"
        abort
    fi
    echo -e "${KEYWORD}#${RESET} KeyShot application found at: ${VARIABLE}$KEYSHOT_APP${RESET}"

    # Prompt user to launch KeyShot
    echo -e "${TEXT_COLOR}#${RESET} Would you like to launch KeyShot now?"
    echo -e -n "Enter ${STRING}(y/n)${RESET}: "
    read -r launch_choice
    if [[ $launch_choice =~ ^[Yy]$ ]]; then
        echo -e "${WARNING}#${RESET} Launching KeyShot..."
        open "$KEYSHOT_APP"
        echo -e "${SUCCESS}#${RESET} KeyShot has been launched."
    else
        echo -e "${TEXT_COLOR}#${RESET} KeyShot launch skipped."
    fi
    
    echo -e "${SUCCESS}#${RESET} Installation complete. Please restart KeyShot to use the AWS Deadline Cloud submission script."
}

# Main execution function
main() {
    local enable_logging=$1
    local skip_keyshot_check=$2

    setup_logging "$enable_logging"
    start_script
    detect_keyshot

    if [[ "$skip_keyshot_check" != "skip_check" ]]; then
        check_keyshot_running
        if [[ $? -eq 2 ]]; then
            # KeyShot was closed, reinvoke the script
            exec bash "$0" "$enable_logging" "skip_check"
        fi
    fi

    create_and_activate_venv
    install_required_packages
    setup_environment_variables
    copy_keyshot_script
    launch_keyshot
}

# Call the main function to start the script
if [[ "$1" == "--log" ]]; then
    if [[ "$2" == "skip_check" ]]; then
        main --log skip_check
    else
        main --log
    fi
else
    if [[ "$1" == "skip_check" ]]; then
        main "" skip_check
    else
        main
    fi
fi
