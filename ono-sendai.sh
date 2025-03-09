#!/usr/bin/env bash
set -eo pipefail

GIST_ID="15fffd75825119592746dff25721e130"
GIST_USER="maskirov"
GIST_URL="https://gist.github.com/${GIST_USER}/${GIST_ID}"
RAW_GIST_URL="https://gist.githubusercontent.com/${GIST_USER}/${GIST_ID}/raw"

echo "==================================================================="
echo "       Ono-Sendai NixOS Cyberpunk Environment Installer"
echo "==================================================================="
echo ""
echo "This script will download and install the Ono-Sendai theme system"
echo "from: ${GIST_URL}"
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

# Check internet connectivity
echo "Checking internet connection..."
if ! ping -c 1 github.com &>/dev/null; then
  echo "Error: No internet connection. Please connect and try again."
  exit 1
fi

# Create temporary directory for downloads
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Creating Ono-Sendai configuration directory..."
mkdir -p /etc/nixos/ono-sendai

# Download all Nix files from the gist
echo "Downloading theme files from gist..."
FILES=(
  "configuration.nix"
  "nixos-fonts-config.nix"
  "nixos-home-manager.nix"
  "nixos-theme-module.nix"
  "theme-generator.nix"
)

for file in "${FILES[@]}"; do
  echo "  Downloading ${file}..."
  curl -s "${RAW_GIST_URL}/${file}" -o "${TEMP_DIR}/${file}"
  
  # Basic validation that we got a proper Nix file
  if ! grep -q "{" "${TEMP_DIR}/${file}"; then
    echo "Error: Downloaded file ${file} does not appear to be a valid Nix file."
    exit 1
  fi
  
  cp "${TEMP_DIR}/${file}" "/etc/nixos/ono-sendai/${file}"
done

# Create a flake.nix that includes our theme files
echo "Creating flake.nix..."
cat > /etc/nixos/flake.nix << 'EOF'
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
          ./ono-sendai/configuration.nix
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixos = import ./ono-sendai/nixos-home-manager.nix;
          }
        ];
      };
    };
}
EOF

# Create a master configuration.nix that imports our theme
echo "Creating main configuration.nix..."
cat > /etc/nixos/configuration.nix << 'EOF'
{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./ono-sendai/nixos-theme-module.nix
      ./ono-sendai/nixos-fonts-config.nix
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

# Create a script to apply the configuration
cat > /etc/nixos/apply-ono-sendai.sh << 'EOF'
#!/usr/bin/env bash
set -eo pipefail

echo "Applying Ono-Sendai NixOS configuration..."

# Rebuild NixOS using flakes
sudo nixos-rebuild switch --flake /etc/nixos#ono-sendai

echo ""
echo "Ono-Sendai theme has been installed!"
echo ""
echo "IMPORTANT:"
echo "1. Change your default password with: passwd"
echo "2. Install Berkeley Mono font for the best experience"
echo "   (Instructions at /etc/berkeley-mono-install-instructions)"
echo "3. Reboot to ensure all changes take effect"
echo ""
echo "Enjoy your cyberpunk NixOS environment!"
EOF

chmod +x /etc/nixos/apply-ono-sendai.sh

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
  /etc/nixos/apply-ono-sendai.sh
else
  echo "You can apply the configuration later by running the script mentioned above."
fi
