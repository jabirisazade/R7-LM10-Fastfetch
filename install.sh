#!/usr/bin/env bash

set -euo pipefail

REPO="https://raw.githubusercontent.com/jabirisazade/R7-LM10-Fastfetch/main"

FASTFETCH_CONFIG_URL="$REPO/fastfetch/config.jsonc"
FASTFETCH_LOGO_URL="$REPO/fastfetch/ronaldooo.png"

KITTY_CONFIG_URL="$REPO/kitty/kitty.conf"
KITTY_THEME_URL="$REPO/kitty/current-theme.conf"

FASTFETCH_DIR="$HOME/.config/fastfetch"
KITTY_DIR="$HOME/.config/kitty"
FONT_DIR="$HOME/.local/share/fonts"

BACKUP_DIR="$HOME/.config/r7-lm10-backup-$(date +%Y%m%d-%H%M%S)"

if [ "$(id -u)" -eq 0 ]; then
    echo
    echo "[ERROR] sudo ile calisdirmayin."
    echo
    echo "Normal user olaraq calisdirin:"
    echo
    echo "curl -fsSL $REPO/install.sh | bash"
    echo
    exit 1
fi

if [ ! -f /etc/os-release ]; then
    echo "[ERROR] Linux sistemi müəyyən edilmedi."
    exit 1
fi

source /etc/os-release

DISTRO="${ID:-unknown}"

echo
echo "============================================================"
echo "                  R7-LM10-Fastfetch"
echo "============================================================"
echo
echo "        Fastfetch + Kitty + Nerd Font installer"
echo
echo "============================================================"
echo
echo "Sistem: $PRETTY_NAME"
echo

install_arch() {

    echo "[INFO] Arch-based sistem aşkarlanildi."

    sudo pacman -S --needed --noconfirm \
        bash \
        curl \
        fastfetch \
        kitty \
        unzip \
        fontconfig

    echo "[OK] Arch paketleri qurasdirildi."
}

install_debian() {

    echo "[INFO] Debian/Ubuntu-based sistem aşkarlanildi."

    sudo apt update

    sudo apt install -y \
        bash \
        curl \
        unzip \
        fontconfig

    if ! command -v fastfetch >/dev/null 2>&1; then
        sudo apt install -y fastfetch
    fi

    if ! command -v kitty >/dev/null 2>&1; then
        sudo apt install -y kitty
    fi

    echo "[OK] Debian/Ubuntu paketleri qurasdirildi."
}

install_nixos() {

    echo "[INFO] NixOS aşkarlanildi."

    if ! command -v nix >/dev/null 2>&1; then
        echo "[ERROR] nix komandasi tapilmadi."
        exit 1
    fi

    nix profile install \
        nixpkgs#bash \
        nixpkgs#fastfetch \
        nixpkgs#kitty

    export PATH="$HOME/.nix-profile/bin:$PATH"

    echo "[OK] NixOS paketleri qurasdirildi."
}

case "$DISTRO" in

    nixos)
        install_nixos
        ;;

    arch|manjaro|endeavouros|garuda|arcolinux)
        install_arch
        ;;

    debian|ubuntu|linuxmint|pop|elementary)
        install_debian
        ;;

    *)
        echo
        echo "[ERROR] Desteklenmeyen Linux sistemi: $DISTRO"
        echo
        echo "Desteklenen sistemler:"
        echo
        echo "  NixOS"
        echo "  Arch Linux"
        echo "  Manjaro"
        echo "  EndeavourOS"
        echo "  Garuda"
        echo "  Debian"
        echo "  Ubuntu"
        echo "  Linux Mint"
        echo "  Pop!_OS"
        echo "  elementary OS"
        echo
        exit 1
        ;;
esac

export PATH="$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH"

echo
echo "[INFO] Config qovluqlari hazirlanir..."

mkdir -p "$FASTFETCH_DIR"
mkdir -p "$KITTY_DIR"
mkdir -p "$FONT_DIR"

if [ -f "$FASTFETCH_DIR/config.jsonc" ] || \
   [ -f "$FASTFETCH_DIR/ronaldooo.png" ] || \
   [ -f "$KITTY_DIR/kitty.conf" ] || \
   [ -f "$KITTY_DIR/current-theme.conf" ]; then

    echo
    echo "[INFO] Mövcud config tapildi."
    echo "[INFO] Backup yaradilir..."

    mkdir -p "$BACKUP_DIR"

    [ -f "$FASTFETCH_DIR/config.jsonc" ] && \
        cp "$FASTFETCH_DIR/config.jsonc" \
        "$BACKUP_DIR/fastfetch-config.jsonc"

    [ -f "$FASTFETCH_DIR/ronaldooo.png" ] && \
        cp "$FASTFETCH_DIR/ronaldooo.png" \
        "$BACKUP_DIR/ronaldooo.png"

    [ -f "$KITTY_DIR/kitty.conf" ] && \
        cp "$KITTY_DIR/kitty.conf" \
        "$BACKUP_DIR/kitty.conf"

    [ -f "$KITTY_DIR/current-theme.conf" ] && \
        cp "$KITTY_DIR/current-theme.conf" \
        "$BACKUP_DIR/current-theme.conf"

    echo "[OK] Backup yaradildi:"
    echo "     $BACKUP_DIR"
fi

echo
echo "[INFO] Fastfetch config yuklenir..."

curl -fsSL "$FASTFETCH_CONFIG_URL" \
    -o "$FASTFETCH_DIR/config.jsonc"

echo "[OK] Fastfetch config qurasdirildi."

echo
echo "[INFO] Fastfetch logosu yuklenir..."

curl -fsSL "$FASTFETCH_LOGO_URL" \
    -o "$FASTFETCH_DIR/ronaldooo.png"

echo "[OK] Fastfetch logosu qurasdirildi."

echo
echo "[INFO] Kitty config yuklenir..."

curl -fsSL "$KITTY_CONFIG_URL" \
    -o "$KITTY_DIR/kitty.conf"

echo "[OK] Kitty config qurasdirildi."

echo
echo "[INFO] Kitty theme yuklenir..."

curl -fsSL "$KITTY_THEME_URL" \
    -o "$KITTY_DIR/current-theme.conf"

echo "[OK] Kitty theme qurasdirildi."

echo
echo "[INFO] JetBrainsMono Nerd Font yuklenir..."

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"

TEMP_FONT="$(mktemp --suffix=.tar.xz)"

curl -fL "$FONT_URL" -o "$TEMP_FONT"

tar -xf "$TEMP_FONT" -C "$FONT_DIR"

rm -f "$TEMP_FONT"

echo "[OK] JetBrainsMono Nerd Font qurasdirildi."

if command -v fc-cache >/dev/null 2>&1; then

    echo
    echo "[INFO] Font cache yenilenir..."

    fc-cache -f "$FONT_DIR"

    echo "[OK] Font cache yenilendi."
fi

echo
echo "[INFO] Final yoxlama..."
echo

echo "------------------------------------------------------------"

command -v bash >/dev/null 2>&1 \
    && echo "  ✓ Bash" \
    || echo "  ✗ Bash"

command -v fastfetch >/dev/null 2>&1 \
    && echo "  ✓ Fastfetch" \
    || echo "  ✗ Fastfetch"

command -v kitty >/dev/null 2>&1 \
    && echo "  ✓ Kitty" \
    || echo "  ✗ Kitty"

[ -f "$FASTFETCH_DIR/config.jsonc" ] \
    && echo "  ✓ Fastfetch config" \
    || echo "  ✗ Fastfetch config"

[ -f "$FASTFETCH_DIR/ronaldooo.png" ] \
    && echo "  ✓ Fastfetch logo" \
    || echo "  ✗ Fastfetch logo"

[ -f "$KITTY_DIR/kitty.conf" ] \
    && echo "  ✓ Kitty config" \
    || echo "  ✗ Kitty config"

[ -f "$KITTY_DIR/current-theme.conf" ] \
    && echo "  ✓ Kitty theme" \
    || echo "  ✗ Kitty theme"

[ -d "$FONT_DIR" ] \
    && echo "  ✓ JetBrainsMono Nerd Font" \
    || echo "  ✗ JetBrainsMono Nerd Font"

echo "------------------------------------------------------------"

echo
echo "============================================================"
echo "              QURASDIRMA TAMAMLANDI"
echo "============================================================"
echo
echo "Fastfetch:"
echo "    fastfetch"
echo
echo "Kitty:"
echo "    kitty"
echo
echo "============================================================"
echo

EOF
