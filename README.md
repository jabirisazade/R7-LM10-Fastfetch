# R7-LM10-Fastfetch

A simple Linux ricing setup featuring **Fastfetch**, **Kitty**, **JetBrainsMono Nerd Font**, and a custom **Ronaldo** Fastfetch logo.

Designed for users who want to quickly set up the same terminal and Fastfetch configuration with a single command.

## ✨ Features

* ⚡ Custom Fastfetch configuration
* 🖼️ Custom Ronaldo Fastfetch logo
* 🐱 Kitty terminal configuration
* 🎨 Custom Kitty theme
* 🔤 JetBrainsMono Nerd Font
* 💾 Automatic backup of existing configurations
* 🐧 Supports multiple Linux distributions
* 🚀 One-command installation

## 🐧 Supported Distributions

* NixOS
* Arch Linux
* Manjaro
* EndeavourOS
* Garuda Linux
* ArcoLinux
* Debian
* Ubuntu
* Linux Mint
* Pop!_OS
* elementary OS

## 🚀 Installation

Open a terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/jabirisazade/R7-LM10-Fastfetch/main/install.sh | bash
```

The installer automatically:

1. Detects your Linux distribution
2. Installs the required packages
3. Installs Fastfetch
4. Installs Kitty
5. Installs JetBrainsMono Nerd Font
6. Downloads the custom Fastfetch configuration
7. Downloads the Ronaldo logo
8. Downloads the Kitty configuration
9. Downloads the Kitty theme
10. Creates a backup of existing configurations

## 📁 Installed Files

### Fastfetch

```text
~/.config/fastfetch/
├── config.jsonc
└── ronaldooo.png
```

### Kitty

```text
~/.config/kitty/
├── kitty.conf
└── current-theme.conf
```

### Fonts

```text
~/.local/share/fonts/
```

## 💾 Backups

If an existing configuration is detected, the installer automatically creates a backup:

```text
~/.config/r7-lm10-backup-YYYYMMDD-HHMMSS/
```

Your existing configuration is not overwritten without a backup.

## ▶️ Usage

After installation, run:

```bash
fastfetch
```

To launch Kitty:

```bash
kitty
```

## 🛠️ Manual Configuration

If you only want the configuration files, you can download them directly from this repository.

```text
fastfetch/config.jsonc
fastfetch/ronaldooo.png
kitty/kitty.conf
kitty/current-theme.conf
```

## 📸 Preview

Add a screenshot of the final setup here:

```markdown
![R7-LM10-Fastfetch Preview](preview.png)
```

## 📜 License

This project is provided for personal and educational use.

Feel free to modify the configuration and create your own Linux rice.

---

Made with ❤️ for Linux
by [Jabir Isazade](https://github.com/jabirisazade)
