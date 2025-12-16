#!/bin/bash

# Update and install fastfetch
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update
sudo apt install fastfetch -y
printf "FASTFETCH INSTALLATION COMPLETED SUCCESSFULLY\n"

# Create configuration directory
mkdir -p ~/.fastfetch-init-terminal-config
printf "CONFIGURATION DIRECTORY CREATED SUCCESSFULLY\n"

# Create flag.txt with "true" if it doesn't exist
if [ ! -f "$HOME/.fastfetch-init-terminal-config/flag.txt" ]; then
	echo "true" > "$HOME/.fastfetch-init-terminal-config/flag.txt"
	printf "FLAG FILE CREATED WITH 'true' SUCCESSFULLY\n"
fi

# Create the fastfetch.sh script inside the configuration directory
cat > "$HOME/.fastfetch-init-terminal-config/fastfetch.sh" <<'FASTFETCH_SCRIPT'
#!/bin/bash

# Path to the control file
file="$HOME/.fastfetch-init-terminal-config/flag.txt"

# If the file exists, read its content and run fastfetch only if it's "true"
if [ -f "$file" ]; then
	content=$(cat "$file")
	if [ "$content" = "true" ]; then
		fastfetch
        echo "false" > "$file"
	fi
fi
FASTFETCH_SCRIPT

# Make the script executable
chmod +x "$HOME/.fastfetch-init-terminal-config/fastfetch.sh"
printf "FASTFETCH SCRIPT CREATED SUCCESSFULLY\n"


# Add block to .bashrc to run fastfetch on bash startup
if ! grep -Fxq '# ========= fastfetch init ==========' "$HOME/.bashrc"; then
	cat >> "$HOME/.bashrc" <<'BASHRC_FASTFETCH'

# ========= fastfetch init ==========
if [ -f "$HOME/.fastfetch-init-terminal-config/fastfetch.sh" ]; then
	"$HOME/.fastfetch-init-terminal-config/fastfetch.sh"
fi
# ===================================

BASHRC_FASTFETCH
fi
printf ".bashrc MODIFIED SUCCESSFULLY\n"

# Create the change-flag.sh script
cat > "$HOME/.fastfetch-init-terminal-config/change-flag.sh" <<'CHANGE_FLAG_SCRIPT'
#!/bin/bash

file="$HOME/.fastfetch-init-terminal-config/flag.txt"

# Check if the file exists
if [ -e "$file" ]; then
    # If it exists, write "true"
    echo "true" > "$file"
fi
CHANGE_FLAG_SCRIPT

# Make the script executable
chmod +x "$HOME/.fastfetch-init-terminal-config/change-flag.sh"
printf "CHANGE-FLAG SCRIPT CREATED SUCCESSFULLY\n"

# Create systemd service to run change-flag.sh on shutdown
sudo tee /etc/systemd/system/fastfetch-reset-flag.service > /dev/null <<SERVICE_UNIT
[Unit]
Description=Reset fastfetch flag to true on shutdown
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target

[Service]
Type=oneshot
ExecStart=$HOME/.fastfetch-init-terminal-config/change-flag.sh
User=$USER

[Install]
WantedBy=halt.target reboot.target shutdown.target
SERVICE_UNIT

# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable fastfetch-reset-flag.service
printf "SHUTDOWN SERVICE CREATED AND ENABLED SUCCESSFULLY\n"


