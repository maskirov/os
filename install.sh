#!/usr/bin/env bash
set -eo pipefail

REPO_URL="https://github.com/maskirov/os.git"
REPO_BRANCH="main"

echo "==================================================================="
echo "       Ono-Sendai NixOS Cyberpunk Environment Installer"
echo "==================================================================="
echo ""
echo "This script will install the Ono-Sendai theme system"
echo "from: ${REPO_URL}"
echo ""

# Check if running as root for system-wide operations
if [ "$EUID" -ne 0 ]; then
  echo "This script needs root privileges to install system components."
  echo "Please run with sudo or as root."
  exit 1
fi

# Ensure we're running on NixOS
if ! grep -q "nixos" /etc/os-release 2>/dev/null; then
  echo "Error: This script must be run on NixOS."
  exit 1
fi

# Check for Git
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Installing git..."
  nix-env -iA nixos.git
fi

# Check internet connectivity
echo "Checking internet connection..."
if ! ping -c 1 github.com &>/dev/null; then
  echo "Error: No internet connection. Please connect and try again."
  exit 1
fi

# Back up existing configuration
echo "Backing up existing NixOS configuration..."
if [ -d "/etc/nixos" ]; then
  BACKUP_DIR="/etc/nixos.backup.$(date +%Y%m%d%H%M%S)"
  mkdir -p "$BACKUP_DIR"
  cp -r /etc/nixos/* "$BACKUP_DIR/"
  echo "Backup created at $BACKUP_DIR"
fi

# Clone the repository
echo "Cloning Ono-Sendai repository..."
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

git clone --depth 1 -b "$REPO_BRANCH" "$REPO_URL" "$TEMP_DIR/os"

# Ensure hardware-configuration.nix exists
if [ ! -f "/etc/nixos/hardware-configuration.nix" ]; then
  echo "Warning: hardware-configuration.nix not found."
  echo "Attempting to generate it..."
  nixos-generate-config --root /
  
  if [ ! -f "/etc/nixos/hardware-configuration.nix" ]; then
    echo "Error: Failed to generate hardware-configuration.nix."
    echo "You may need to create this file manually before proceeding."
    exit 1
  fi
fi

# Copy hardware-configuration.nix to ensure it's preserved
cp /etc/nixos/hardware-configuration.nix "$TEMP_DIR/hardware-configuration.nix"

# Create flake.nix in the temp directory
cat > "$TEMP_DIR/flake.nix" << 'EOF'
{
  description = "NixOS configuration with Ono-Sendai cyberpunk theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # Change to aarch64-linux for ARM systems
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.ono-sendai = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixos = import ./os/nixos-home-manager.nix;
          }
        ];
      };
    };
}
EOF

# Create configuration.nix in the temp directory
cat > "$TEMP_DIR/configuration.nix" << 'EOF'
{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./os/nixos-theme-module.nix
      ./os/nixos-fonts-config.nix
    ];

  # Include Ono-Sendai theme
  themes.ono-sendai = {
    enable = true;
    themeName = "ono-sendai";
    shortName = "os";
    applications = {
      i3 = true;
      polybar = true;
      tmux = true;
      alacritty = true;
      neovim = true;
      emacs = true;
      rofi = true;
      ghostty = true;
      starship = true;
      dircolors = true;
    };
  };

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Networking
  networking = {
    hostName = "ono-sendai";
    networkmanager.enable = true;
  };

  # Set your time zone
  time.timeZone = "America/Los_Angeles"; # Change to your timezone

  # Localization
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Define a user account
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    initialPassword = "nixos"; # Change this after first login
    shell = pkgs.bash;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Used for state management
  system.stateVersion = "23.11";
}
EOF

# Create the apply script - MODIFIED to avoid writing to nix.conf
cat > "$TEMP_DIR/apply-ono-sendai.sh" << 'EOF'
#!/usr/bin/env bash
set -eo pipefail

echo "Applying Ono-Sendai NixOS configuration..."

# Check if hardware-configuration.nix exists
if [ ! -f /etc/nixos/hardware-configuration.nix ]; then
  echo "Error: hardware-configuration.nix not found."
  echo "This file is required and should be generated during NixOS installation."
  echo "You may need to copy it from another location or regenerate it."
  exit 1
fi

# Set environment variable for flakes if not already enabled in nix.conf
if ! grep -q "experimental-features.*flakes" /etc/nix/nix.conf 2>/dev/null; then
  echo "Enabling flakes via environment variable..."
  export NIX_CONFIG="experimental-features = nix-command flakes"
fi

# Rebuild NixOS using flakes
nixos-rebuild switch --flake /etc/nixos#ono-sendai

echo ""
echo "Ono-Sendai theme has been installed!"
echo ""
echo "IMPORTANT:"
echo "1. Change your default password with: passwd"
echo "2. Install Berkeley Mono font for the best experience"
echo "   (Instructions at /etc/berkeley-mono-install-instructions)"
echo "3. Reboot to ensure all changes take effect"
echo ""
echo "If you receive warnings about experimental features, add this to your shell profile:"
echo "export NIX_CONFIG=\"experimental-features = nix-command flakes\""
echo ""
echo "Enjoy your cyberpunk NixOS environment!"
EOF

chmod +x "$TEMP_DIR/apply-ono-sendai.sh"

# Copy everything to /etc/nixos
echo "Installing files to /etc/nixos..."
cp -r "$TEMP_DIR/os" /etc/nixos/
cp "$TEMP_DIR/flake.nix" /etc/nixos/
cp "$TEMP_DIR/configuration.nix" /etc/nixos/
cp "$TEMP_DIR/hardware-configuration.nix" /etc/nixos/
cp "$TEMP_DIR/apply-ono-sendai.sh" /etc/nixos/

echo ""
echo "Setup complete! To apply the Ono-Sendai configuration, run:"
echo ""
echo "  /etc/nixos/apply-ono-sendai.sh"
echo ""
echo "Note: Make sure to change your password after installation."
echo "Default username: nixos"
echo "Default password: nixos"
echo ""
echo "Do you want to apply the configuration now? (y/N)"
read -r APPLY_NOW

if [[ "$APPLY_NOW" =~ ^[Yy]$ ]]; then
  echo "Applying configuration..."
  export NIX_CONFIG="experimental-features = nix-command flakes"
  /etc/nixos/apply-ono-sendai.sh
else
  echo "You can apply the configuration later by running the script mentioned above."
fi
