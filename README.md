# 🍙 My Dotfiles

![My Setup](waybar/image.png)

> A screenshot of my desktop setup (Hyprland + Waybar)

A collection of configuration files (dotfiles) for my Arch Linux setup using **Hyprland** and **Waybar**, featuring the Catppuccin Mocha theme.

---

## 🖼️ Gallery

| Desktop | App Launcher |
|:---:|:---:|
| <img src="waybar/image3.png" alt="Desktop" width="400"/> | <img src="waybar/image2.png" alt="Launcher" width="400"/> |
| *Clean State* | *App Launcher* |

---

## 🛠️ Details

- **OS**: Arch Linux
- **WM**: [Hyprland](https://github.com/hyprwm/Hyprland)
- **Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **Terminal**: Kitty
- **Shell**: Bash
- **Launcher**: Rofi
- **GTK Theme**: Catppuccin Mocha Mauve
- **Icons**: Tela-dark
- **Cursor**: Deepin
- **Font**: SF Compact Display Medium & Nerd Fonts

---

## 📂 Structure

\`\`\`text
dotfiles/
├── fonts/                # Custom font collection
├── gtk-3.0/              # GTK 3 configuration
├── gtk-4.0/              # GTK 4 configuration
├── hypr/                 # Main Hyprland configuration
├── networkmanager-dmenu/ # WiFi menu configuration
├── rofi/                 # App Launcher configuration
├── waybar/               # Waybar configuration + styling + scripts
├── install.sh            # Smart script for automated setup & symlinking
└── README.md
\`\`\`

---

## 🚀 Installation

### 1️⃣ Clone the Repository

\`\`\`bash
git clone https://github.com/jihan431/dotfiles.git ~/dotfiles
cd ~/dotfiles
\`\`\`

### 2️⃣ Run the Install Script

This installation script will automatically backup your old configurations in `.config/`, download required themes via AUR (`yay`/`paru`), and create clean symlinks.

\`\`\`bash
chmod +x install.sh
./install.sh
\`\`\`

---

## 🔤 Font Requirements

- **SF Compact Display** (Automatically linked if present in the `fonts/` folder)
- **Nerd Fonts** (Required to render Waybar & Rofi icons correctly)
  [Download Nerd Fonts here](https://www.nerdfonts.com/)

---

## ⌨️ Keybinds

| Key | Action |
| :--- | :--- |
| `Super + Q` | Close App |
| `Super + Enter` | Open Terminal |
| `Super + E` | File Manager |
| `Super + Space` | App Launcher (Rofi) |