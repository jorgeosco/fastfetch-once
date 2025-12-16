#!/bin/bash

# Uninstall script - Removes everything setup.sh created

echo "Starting ..."

# Disable and remove systemd service
if systemctl is-enabled fastfetch-reset-flag.service &>/dev/null; then
	sudo systemctl disable fastfetch-reset-flag.service
	printf "SYSTEMD SERVICE DISABLED SUCCESSFULLY\n"
fi

if systemctl is-active fastfetch-reset-flag.service &>/dev/null; then
	sudo systemctl stop fastfetch-reset-flag.service
	printf "SYSTEMD SERVICE STOPPED SUCCESSFULLY\n"
fi

if [ -f /etc/systemd/system/fastfetch-reset-flag.service ]; then
	sudo rm /etc/systemd/system/fastfetch-reset-flag.service
	sudo systemctl daemon-reload
	printf "SYSTEMD SERVICE REMOVED SUCCESSFULLY\n"
fi

# Remove fastfetch init block from .bashrc
if grep -Fxq '# ========= fastfetch init ==========' "$HOME/.bashrc"; then
	# Create temporary file without the fastfetch block
	sed '/# ========= fastfetch init ==========/,/# ===================================/d' "$HOME/.bashrc" > "$HOME/.bashrc.tmp"
	mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"
	printf ".bashrc CLEANED SUCCESSFULLY\n"
fi

# Remove configuration directory and all its contents
if [ -d "$HOME/.fastfetch-init-terminal-config" ]; then
	rm -rf "$HOME/.fastfetch-init-terminal-config"
	printf "CONFIGURATION DIRECTORY REMOVED SUCCESSFULLY\n"
fi

printf "SUCCESS.\n"
