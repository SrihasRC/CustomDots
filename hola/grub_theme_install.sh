#!/bin/bash

# ===============================
# Universal GRUB Theme Installer
# ===============================

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo " Please run as root (use sudo)."
  exit 1
fi

# Ask for theme source path
read -rp "Enter the full path to your GRUB theme folder: " THEME_SOURCE

# Verify theme source
if [ ! -d "$THEME_SOURCE" ]; then
  echo " Error: Directory '$THEME_SOURCE' does not exist."
  exit 1
fi

# Extract theme name from folder
THEME_NAME=$(basename "$THEME_SOURCE")
THEME_DEST="/boot/grub/themes/$THEME_NAME"

# Config paths
GRUB_CFG="/etc/default/grub"
BACKUP_CFG="/etc/default/grub.backup.$(date +%Y%m%d%H%M%S)"

# Create themes directory if missing
mkdir -p /boot/grub/themes

# Backup grub config
echo " Backing up GRUB config to $BACKUP_CFG"
cp "$GRUB_CFG" "$BACKUP_CFG"

# Copy theme to /boot/grub/themes
echo " Copying theme to $THEME_DEST"
cp -r "$THEME_SOURCE" "$THEME_DEST"

# Update GRUB_THEME line
if grep -q "^GRUB_THEME=" "$GRUB_CFG"; then
    sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$THEME_DEST/theme.txt\"|" "$GRUB_CFG"
else
    echo "GRUB_THEME=\"$THEME_DEST/theme.txt\"" | tee -a "$GRUB_CFG"
fi

# Update grub
echo "Updating GRUB..."
if command -v update-grub >/dev/null 2>&1; then
    update-grub
elif command -v grub-mkconfig >/dev/null 2>&1; then
    grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "Could not find update-grub or grub-mkconfig. Update manually!"
fi

# Done
echo "Done! Reboot to see your new theme."
echo "If something breaks, restore backup with:"
echo "  sudo cp $BACKUP_CFG $GRUB_CFG && sudo update-grub"
