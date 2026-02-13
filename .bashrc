#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Blesh (Auto-suggestions) ---
if [[ -f "$HOME/.local/share/blesh/ble.sh" ]]; then
    source "$HOME/.local/share/blesh/ble.sh" --noattach
elif [[ -f /usr/share/blesh/ble.sh ]]; then
    source /usr/share/blesh/ble.sh --noattach
fi

# Enable bash completion (System)
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Exports
export PATH="$PATH:$HOME/depot_tools"
export VPYTHON_BYPASS="manually managed python not supported by chrome operations"
export PATH="$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- MINIMALIST PS1 PROMPT ---
C_CYAN='\[\e[1;36m\]'
C_RESET='\[\e[0m\]'
PS1="${C_CYAN}󰣇  \u ${C_RESET}• ${C_CYAN}\w ${C_CYAN}❯${C_RESET} "

# --- Fastfetch Execution ---
if command -v fastfetch &> /dev/null; then
    fastfetch
    echo "" # Menambahkan jarak ke bawah
fi

# Attach Blesh at the end
if [[ ${BLE_VERSION-} ]]; then
    ble-attach
fi
alias ai='python3 ~/ai-gue/gemini-term.py'
alias scrcpy-dev="scrcpy --max-size 1024 --video-bit-rate 2M --max-fps 60 --turn-screen-off --window-title 'My Xiaomi'"
