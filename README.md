# Fastfetch Once

See fastfetch once per boot session, not every time you open a new terminal window.

## What does `setup.sh` do?

- Installs `fastfetch` on your Ubuntu system
- Creates a configuration directory at `~/.fastfetch-init-terminal-config`
- Sets up a control mechanism using `flag.txt` to display fastfetch only once per boot
- Adds an automatic hook to your `.bashrc` to run fastfetch on terminal startup
- Creates a systemd service that resets the flag on system shutdown/reboot

## Installation

### Make the script executable

```bash
chmod +x setup.sh
```

### Run the script

```bash
./setup.sh
```

The script will request `sudo` privileges to install packages and create the systemd service.

## Remove Configuration

If you want to remove all configurations and revert the changes made by `setup.sh`:

### Make the cleanup script executable

```bash
chmod +x delete-settings.sh
```

### Run the cleanup script

```bash
./delete-settings.sh
```

This will remove the systemd service, clean up `.bashrc`, and delete the configuration directory. Fastfetch itself will remain installed.

