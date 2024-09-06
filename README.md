# STARK - Scripted Tool for AWS Rendering Kickoff
## AWS Deadline Cloud for KeyShot - macOS Setup Script

STARK-DC automates the integration of AWS Deadline Cloud with KeyShot on macOS, streamlining the setup process to allow users to quickly begin leveraging cloud-based rendering capabilities.

## Features

- Automatic detection of installed KeyShot versions
- Installation of Xcode Command Line Tools if not present
- Creation and activation of a Python virtual environment
- Installation of required Python packages: `deadline-cloud-for-keyshot` and `deadline[gui]`
- Download and placement of AWS Deadline Cloud submission script in the appropriate KeyShot Scripts folder
- Setup of necessary environment variables for AWS Deadline Cloud integration
- Creation of a LaunchAgent for persistent environment variable setup
- Creation of a KeyShot DC Launcher app and addition to the Dock
- Logging capability for troubleshooting

## Prerequisites

- macOS operating system
- KeyShot installed
- Internet connection

## Installation

**Quick Install (One-Line Command)**
For a quick installation, you can use the following command which downloads and runs the script in one step:

   ```
   curl -sO https://raw.githubusercontent.com/JonathanAlbarran/deadline-cloud-for-keyshot-macos/main/install_deadline_cloud_keyshot_macos.sh && bash install_deadline_cloud_keyshot_macos.sh
   ```

1. **Download the installation script:**
   ```
   curl -sO https://raw.githubusercontent.com/JonathanAlbarran/deadline-cloud-for-keyshot-macos/main/install_deadline_cloud_keyshot_macos.sh
   ```

2. **Run the installation script:**
   ```
   bash install_deadline_cloud_keyshot_macos.sh
   ```

3. **Follow the prompts during the installation process.**

## Logging

To enable logging, run the script with the `--log` flag:
```
bash install_deadline_cloud_keyshot_macos.sh --log
```
The log file will be created at `~/Documents/setup_deadline_keyshot.log`.

## Script Behavior

- The script will detect installed KeyShot versions and prompt you to choose one if multiple versions are found.
- If KeyShot is running, the script will provide options to save your work and close KeyShot, force close KeyShot, or exit the script.
- The script will check for and install Xcode Command Line Tools if necessary.
- It will create a Python virtual environment and install the required packages.
- The script will set up required environment variables and create a launch agent to ensure these variables are set for KeyShot.
- The AWS Deadline Cloud submission script will be downloaded and placed in the appropriate KeyShot Scripts folder.
- A KeyShot DC Launcher app will be created and added to the Dock for easy access.
- At the end of the installation, you'll receive instructions on how to launch KeyShot with the correct environment settings.

## Usage

After installation, always use the "KeyShot DC Launcher" from your Applications folder or Dock to start KeyShot. This ensures that KeyShot runs with the necessary environment variables for AWS Deadline Cloud integration.

## Troubleshooting

If you encounter any issues during the setup process, refer to the log file (if logging was enabled) for detailed information. You can also check the [GitHub repository](https://github.com/JonathanAlbarran/deadline-cloud-for-keyshot-macos) for known issues or to report new ones.

## Acknowledgements

This script is based on the [AWS Deadline Cloud for KeyShot](https://github.com/aws-deadline/deadline-cloud-for-keyshot) project and has been adapted for macOS by Jonathan Albarran.
