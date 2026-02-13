#!/bin/bash

# Definisikan lokasi folder
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
# Buat folder backup dengan penanda waktu biar rapi
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Daftar aplikasi di dalam .config yang mau di-symlink
CONFIG_APPS=("hypr" "waybar" "rofi" "swww" "gtk-3.0" "gtk-4.0")

echo "========================================"
echo "🚀 Memulai Setup Dotfiles Otomatis..."
echo "========================================"

# Looping untuk setiap aplikasi
for app in "${CONFIG_APPS[@]}"; do
    TARGET="$CONFIG_DIR/$app"
    SOURCE="$DOTFILES_DIR/$app"

    # Cek apakah folder sumber ada di dotfiles kita
    if [ -d "$SOURCE" ]; then
        echo "Memproses: $app..."

        # Skenario 1: Jika target sudah ada dan berupa symlink (meskipun rusak/looping)
        if [ -L "$TARGET" ]; then
            echo "  [!] Symlink lama ditemukan. Menghapus symlink..."
            rm "$TARGET"
        
        # Skenario 2: Jika target ada dan berupa folder asli (bukan symlink)
        elif [ -d "$TARGET" ]; then
            echo "  [!] Folder asli ditemukan. Mem-backup ke $BACKUP_DIR..."
            mkdir -p "$BACKUP_DIR"
            mv "$TARGET" "$BACKUP_DIR/"
        fi

        # Buat symlink baru yang bersih
        ln -s "$SOURCE" "$TARGET"
        echo "  [✔] Symlink berhasil dibuat!"
    else
        echo "  [?] Lewati $app: Folder tidak ditemukan di ~/dotfiles."
    fi
done

echo "========================================"
echo "🎉 Setup Selesai! Dotfiles sudah terhubung."
echo "Backup konfigurasi lama (jika ada) tersimpan di: $BACKUP_DIR"
echo "========================================"
