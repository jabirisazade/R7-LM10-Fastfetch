#!/usr/bin/env bash

set -euo pipefail

REPO="https://raw.githubusercontent.com/jabirisazade/R7-LM10-Fastfetch/main"

FASTFETCH_CONFIG_URL="$REPO/fastfetch/config.jsonc"
KITTY_CONFIG_URL="$REPO/kitty/kitty.conf"

FASTFETCH_DIR="$HOME/.config/fastfetch"
KITTY_DIR="$HOME/.config/kitty"
FONT_DIR="$HOME/.local/share/fonts"

BACKUP_DIR="$HOME/.config/r7-lm10-backup-$(date +%Y%m%d-%H%M%S)"

if [ "$(id -u)" -eq 0 ]; then
    echo "Xeta: sudo ile calisdirmayin."
    exit 1
fi

if [ ! -f /etc/os-release ]; then
    echo "Xeta: Linux sistemi müəyyən edilmedi."
    exit 1
fi

source /etc/os-release

DISTRO="${ID:-unknown}"

echo
echo "============================================================"
echo "                  R7-LM10-Fastfetch"
echo "============================================================"
echo
echo "        Fastfetch + Kitty + JetBrainsMono Nerd Font"
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
}

install_nixos() {
    echo "[INFO] NixOS aşkarlanildi."

    if ! command -v nix >/dev/null 2>&1; then
        echo "Xeta: nix komandasi tapilmadi."
        exit 1
    fi

    nix profile install \
        nixpkgs#bash \
        nixpkgs#fastfetch \
        nixpkgs#kitty

    export PATH="$HOME/.nix-profile/bin:$PATH"
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
        echo "Xeta: desteklenmeyen Linux sistemi: $DISTRO"
        exit 1
        ;;
esac

export PATH="$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH"

echo
echo "[INFO] Konfiqurasiyalar hazirlanir..."

if [ -f "$FASTFETCH_DIR/config.jsonc" ] || [ -f "$KITTY_DIR/kitty.conf" ]; then
    mkdir -p "$BACKUP_DIR"

    if [ -f "$FASTFETCH_DIR/config.jsonc" ]; then
        cp "$FASTFETCH_DIR/config.jsonc" \
           "$BACKUP_DIR/fastfetch-config.jsonc"
    fi

    if [ -f "$KITTY_DIR/kitty.conf" ]; then
        cp "$KITTY_DIR/kitty.conf" \
           "$BACKUP_DIR/kitty.conf"
    fi

    echo "[OK] Kohne konfiqurasiyalar backup edildi:"
    echo "     $BACKUP_DIR"
fi

mkdir -p "$FASTFETCH_DIR"
mkdir -p "$KITTY_DIR"
mkdir -p "$FONT_DIR"

echo
echo "[INFO] Fastfetch konfiqurasiyasi yuklenir..."

curl -fsSL "$FASTFETCH_CONFIG_URL" \
    -o "$FASTFETCH_DIR/config.jsonc"

echo "[OK] Fastfetch config qurasdirildi."

echo
echo "[INFO] Kitty konfiqurasiyasi yuklenir..."

curl -fsSL "$KITTY_CONFIG_URL" \
    -o "$KITTY_DIR/kitty.conf"

echo "[OK] Kitty config qurasdirildi."

echo
echo "[INFO] JetBrainsMono Nerd Font yuklenir..."

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"

TEMP_FONT="$(mktemp --suffix=.tar.xz)"

curl -fL "$FONT_URL" -o "$TEMP_FONT"

tar -xf "$TEMP_FONT" -C "$FONT_DIR"

rm -f "$TEMP_FONT"

echo "[OK] JetBrainsMono Nerd Font qurasdirildi."

if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$FONT_DIR"
    echo "[OK] Font cache yenilendi."
fi

echo
echo "============================================================"
echo "              QURASDIRMA TAMAMLANDI"
echo "============================================================"
echo
echo "Fastfetch:"
echo "  fastfetch"
echo
echo "Kitty:"
echo "  kitty"
echo
echo "============================================================"
