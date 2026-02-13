#!/bin/bash

# Warna untuk output agar estetik
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo -e "${PURPLE}======================================${NC}"
echo -e "${PURPLE}   SYMLINK SETUP (No Installation)    ${NC}"
echo -e "${PURPLE}======================================${NC}"

# Fungsi untuk membuat symlink secara aman
link_folder() {
    local folder=$1
    local src="$DOTFILES_DIR/$folder"
    local dest="$CONFIG_DIR/$folder"

    if [ -d "$src" ]; then
        echo -e "${BLUE}[Processing]${NC} $folder"
        
        # Hapus jika folder/link lama sudah ada agar tidak loop
        if [ -d "$dest" ] || [ -L "$dest" ]; then
            rm -rf "$dest"
        fi
        
        # Buat symlink baru
        ln -s "$src" "$dest"
        echo -e "${GREEN}[Success]${NC} $folder linked."
    else
        echo -e "${BLUE}[Skipped]${NC} $folder not found in dotfiles."
    fi
}

# 1. Pastikan direktori .config ada
mkdir -p "$CONFIG_DIR"

# 2. List folder yang mau di-link (tambah/hapus sesuai kebutuhan)
link_folder "hypr"
link_folder "waybar"
link_folder "rofi"
link_folder "eww"
link_folder "networkmanager-dmenu"
link_folder "gtk-3.0"
link_folder "gtk-4.0"

# 3. Khusus untuk file di root home (seperti .bashrc)
if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    rm -f "$HOME/.bashrc"
    ln -s "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    echo -e "${GREEN}[Success]${NC} .bashrc linked."
fi

echo -e "${PURPLE}======================================${NC}"
echo -e "${GREEN}  All symlinks are now up to date!   ${NC}"
echo -e "${PURPLE}======================================${NC}"
