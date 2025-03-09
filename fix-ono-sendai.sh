#!/usr/bin/env bash
set -eo pipefail

# Ono-Sendai NixOS Cyberpunk Theme Bug Fix Script
# This script patches various issues in the theme files and installs them

echo "============================================================"
echo "       Ono-Sendai NixOS Theme Bug Fix & Installer"
echo "============================================================"

# Check if running as root
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

# Create temporary directory for our fixes
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Creating temporary work directory at $TEMP_DIR"
mkdir -p "$TEMP_DIR/ono-sendai"

# -----------------------------------------------------
# Fix 1: Missing theme-generator.nix file
# -----------------------------------------------------
echo "Creating missing theme-generator.nix file..."

cat > "$TEMP_DIR/ono-sendai/theme-generator.nix" << 'EOF'
{ pkgs ? import <nixpkgs> {}, 
  lib ? pkgs.lib,
  themeName ? "ono-sendai",
  themeShortName ? "os",
}:

let 
  # Core color palette
  colors = rec {
    # Backgrounds (from darkest to lightest)
    bg = {
      base = "#101216";
      surface = "#161B22";
      elevated = "#1C2129";
      border = "#21262D";
      highlight = "#2B3038";
    };
    
    # Text colors (from brightest to most subtle)
    fg = {
      primary = "#E2E4E8";
      secondary = "#C9CCD1";
      tertiary = "#8B949E";
      quaternary = "#6E7681";
      quinary = "#484F58";
    };
    
    # Primary accent (blue)
    blue = {
      brightest = "#58A6FF";
      bright = "#388BFD";
      mid = "#1F6FEB";
      deep = "#0D4A85";
      darkest = "#083061";
    };
    
    # Secondary accent (purple)
    purple = {
      brightest = "#BC8CFF";
      bright = "#A371F7";
      mid = "#8957E5";
      deep = "#6E40C9";
      darkest = "#553098";
    };
    
    # Success colors (green)
    green = {
      lightest = "#7EE787";
      light = "#56D364";
      mid = "#3FB950";
      deep = "#2EA043";
      darkest = "#238636";
    };
    
    # Warning colors (orange)
    orange = {
      light = "#F7BE4F";
      mid = "#F0883E";
      deep = "#DB6D28";
      burnt = "#BD561D";
      darkest = "#9E4216";
    };
    
    # Error colors (red)
    red = {
      light = "#FF7B72";
      mid = "#F85149";
      deep = "#DA3633";
      dark = "#B62324";
      darkest = "#8E1519";
    };
    
    # Tertiary accent (cyan)
    cyan = {
      light = "#76E3EC";
      mid = "#39C5CF";
      deep = "#1B9AAA";
      dark = "#0F7285";
      darkest = "#0A5566";
    };
    
    # ANSI Terminal colors
    ansi = {
      black = bg.base;
      red = red.mid;
      green = green.mid;
      yellow = orange.mid;
      blue = blue.brightest;
      magenta = purple.bright;
      cyan = cyan.mid;
      white = fg.primary;
      
      brightBlack = bg.highlight;
      brightRed = red.light;
      brightGreen = green.light;
      brightYellow = orange.light;
      brightBlue = blue.bright;
      brightMagenta = purple.brightest;
      brightCyan = cyan.light;
      brightWhite = fg.primary;
    };
  };
  
  # Helper functions
  fileFromTemplate = name: content: 
    pkgs.writeTextFile {
      name = name;
      text = content;
    };
  
  # Generate all theme files
  emacsTheme = fileFromTemplate "${themeName}-theme.el" ''
    ;;; ${themeName}-theme.el --- A cyberpunk color theme for Emacs -*- lexical-binding: t -*-

    ;; Author: Generated from Nix
    ;; Version: 1.0.0

    ;;; Commentary:
    ;; A dark cyberpunk theme inspired by Ono-Sendai aesthetics

    ;;; Code:

    (deftheme ${themeName}
      "A cyberpunk interface for elite hackers")

    (let ((bg-base           "${colors.bg.base}")
          (bg-surface        "${colors.bg.surface}")
          (bg-elevated       "${colors.bg.elevated}")
          (bg-border         "${colors.bg.border}")
          (bg-highlight      "${colors.bg.highlight}")
          (fg-primary        "${colors.fg.primary}")
          (fg-secondary      "${colors.fg.secondary}")
          (fg-tertiary       "${colors.fg.tertiary}")
          (blue-brightest    "${colors.blue.brightest}")
          (blue-bright       "${colors.blue.bright}")
          (blue-mid          "${colors.blue.mid}")
          (blue-deep         "${colors.blue.deep}")
          (purple-brightest  "${colors.purple.brightest}")
          (purple-bright     "${colors.purple.bright}")
          (green-light       "${colors.green.light}")
          (red-mid           "${colors.red.mid}")
          (cyan-light        "${colors.cyan.light}")
          (cyan-mid          "${colors.cyan.mid}"))
      
      (custom-theme-set-faces
       '${themeName}
       `(default ((t (:background ,bg-base :foreground ,fg-primary))))
       `(cursor ((t (:background ,blue-brightest))))
       `(region ((t (:background ,blue-deep))))
       `(mode-line ((t (:background ,bg-elevated :foreground ,fg-primary))))
       `(mode-line-inactive ((t (:background ,bg-surface :foreground ,fg-tertiary))))
       `(font-lock-comment-face ((t (:foreground ,fg-tertiary))))
       `(font-lock-string-face ((t (:foreground ,green-light))))
       `(font-lock-keyword-face ((t (:foreground ,purple-brightest))))
       `(font-lock-function-name-face ((t (:foreground ,blue-brightest))))
       `(font-lock-variable-name-face ((t (:foreground ,blue-bright))))
       `(font-lock-type-face ((t (:foreground ,cyan-light))))
       `(font-lock-constant-face ((t (:foreground ,cyan-mid)))))))

    (provide-theme '${themeName})
    ;;; ${themeName}-theme.el ends here
  '';
  
  # Generate Vim theme
  nvimTheme = fileFromTemplate "${themeName}.vim" ''
    " ${themeName}.vim - A cyberpunk interface for elite hackers
    
    set background=dark
    hi clear
    if exists("syntax_on")
      syntax reset
    endif
    let g:colors_name="${themeName}"
    
    " Background and foreground
    hi Normal guifg=${colors.fg.primary} guibg=${colors.bg.base}
    
    " UI elements
    hi ColorColumn guibg=${colors.bg.surface}
    hi Cursor guifg=${colors.bg.base} guibg=${colors.blue.brightest}
    hi CursorLine guibg=${colors.bg.surface}
    hi CursorLineNr guifg=${colors.fg.primary} guibg=${colors.bg.surface}
    hi LineNr guifg=${colors.fg.quaternary} guibg=${colors.bg.base}
    hi NonText guifg=${colors.fg.quinary}
    hi VertSplit guifg=${colors.bg.border} guibg=${colors.bg.base}
    
    " Syntax highlighting
    hi Comment guifg=${colors.fg.tertiary}
    hi Constant guifg=${colors.cyan.mid}
    hi String guifg=${colors.green.light}
    hi Identifier guifg=${colors.blue.bright}
    hi Function guifg=${colors.blue.brightest}
    hi Statement guifg=${colors.purple.brightest}
    hi Type guifg=${colors.cyan.light}
    
    " Terminal colors
    let g:terminal_color_0="${colors.ansi.black}"
    let g:terminal_color_1="${colors.ansi.red}"
    let g:terminal_color_2="${colors.ansi.green}"
    let g:terminal_color_3="${colors.ansi.yellow}"
    let g:terminal_color_4="${colors.ansi.blue}"
    let g:terminal_color_5="${colors.ansi.magenta}"
    let g:terminal_color_6="${colors.ansi.cyan}"
    let g:terminal_color_7="${colors.ansi.white}"
    let g:terminal_color_8="${colors.ansi.brightBlack}"
    let g:terminal_color_9="${colors.ansi.brightRed}"
    let g:terminal_color_10="${colors.ansi.brightGreen}"
    let g:terminal_color_11="${colors.ansi.brightYellow}"
    let g:terminal_color_12="${colors.ansi.brightBlue}"
    let g:terminal_color_13="${colors.ansi.brightMagenta}"
    let g:terminal_color_14="${colors.ansi.brightCyan}"
    let g:terminal_color_15="${colors.ansi.brightWhite}"
  '';
  
  # Generate Lua theme
  nvimLuaTheme = fileFromTemplate "${themeName}.lua" ''
    -- ${themeName}.lua - A cyberpunk interface for elite hackers
    
    local colors = {
      bg = {
        base = "${colors.bg.base}",
        surface = "${colors.bg.surface}",
        elevated = "${colors.bg.elevated}",
      },
      fg = {
        primary = "${colors.fg.primary}",
        tertiary = "${colors.fg.tertiary}",
      },
      blue = {
        brightest = "${colors.blue.brightest}",
      },
      purple = {
        brightest = "${colors.purple.brightest}",
      },
      green = {
        light = "${colors.green.light}",
      },
      cyan = {
        light = "${colors.cyan.light}",
        mid = "${colors.cyan.mid}",
      }
    }
    
    local ${themeShortName} = {}
    
    function ${themeShortName}.setup()
      vim.cmd('hi clear')
      vim.cmd('syntax reset')
      vim.g.colors_name = "${themeName}"
      
      -- UI elements
      vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg.primary, bg = colors.bg.base })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.bg.surface })
      
      -- Syntax highlighting
      vim.api.nvim_set_hl(0, "Comment", { fg = colors.fg.tertiary })
      vim.api.nvim_set_hl(0, "String", { fg = colors.green.light })
      vim.api.nvim_set_hl(0, "Function", { fg = colors.blue.brightest })
      vim.api.nvim_set_hl(0, "Keyword", { fg = colors.purple.brightest })
      vim.api.nvim_set_hl(0, "Type", { fg = colors.cyan.light })
      vim.api.nvim_set_hl(0, "Constant", { fg = colors.cyan.mid })
    end
    
    return ${themeShortName}
  '';
  
  # Generate tmux theme
  tmuxTheme = fileFromTemplate "${themeName}-tmux.conf" ''
    # ${themeName} tmux theme
    
    # Status bar colors
    set -g status-style bg=${colors.bg.surface},fg=${colors.fg.primary}
    
    # Window status
    set -g window-status-format "#[fg=${colors.fg.tertiary}]#I:#W"
    set -g window-status-current-format "#[fg=${colors.blue.brightest},bold]#I:#W"
    
    # Pane borders
    set -g pane-border-style fg=${colors.bg.border}
    set -g pane-active-border-style fg=${colors.blue.mid}
  '';
  
  # Generate Starship prompt config
  starshipConfig = fileFromTemplate "${themeName}-starship.toml" ''
    # ${themeName} Starship prompt configuration
    
    # Prompt characters
    [character]
    success_symbol = "[➜](${colors.green.mid})"
    error_symbol = "[✗](${colors.red.mid})"
    
    # Directory
    [directory]
    style = "${colors.blue.brightest}"
    truncation_length = 3
    
    # Git branch
    [git_branch]
    symbol = " "
    style = "${colors.purple.bright}"
  '';
  
  # Generate dircolors
  dircolorsConfig = fileFromTemplate "${themeName}.dircolors" ''
    # ${themeName} dircolors configuration
    
    # Default colors
    NORMAL 00
    FILE 00
    DIR 01;34
    LINK 01;36
    EXEC 01;32
  '';
  
  # Generate Alacritty config
  alacrittyConfig = fileFromTemplate "${themeName}-alacritty.yml" ''
    # ${themeName} Alacritty colors
    
    colors:
      # Default colors
      primary:
        background: '${colors.bg.base}'
        foreground: '${colors.fg.primary}'
      
      # Normal colors
      normal:
        black: '${colors.ansi.black}'
        red: '${colors.ansi.red}'
        green: '${colors.ansi.green}'
        yellow: '${colors.ansi.yellow}'
        blue: '${colors.ansi.blue}'
        magenta: '${colors.ansi.magenta}'
        cyan: '${colors.ansi.cyan}'
        white: '${colors.ansi.white}'
      
      # Bright colors
      bright:
        black: '${colors.ansi.brightBlack}'
        red: '${colors.ansi.brightRed}'
        green: '${colors.ansi.brightGreen}'
        yellow: '${colors.ansi.brightYellow}'
        blue: '${colors.ansi.brightBlue}'
        magenta: '${colors.ansi.brightMagenta}'
        cyan: '${colors.ansi.brightCyan}'
        white: '${colors.ansi.brightWhite}'
  '';
  
  # Generate i3 config colors
  i3Config = fileFromTemplate "${themeName}-i3-colors" ''
    # ${themeName} i3 colors
    
    # class                 border              background         text                indicator          child_border
    client.focused          ${colors.blue.mid}  ${colors.blue.mid} ${colors.fg.primary} ${colors.blue.bright} ${colors.blue.mid}
    client.focused_inactive ${colors.bg.border} ${colors.bg.border} ${colors.fg.tertiary} ${colors.bg.border} ${colors.bg.border}
    client.unfocused        ${colors.bg.surface} ${colors.bg.surface} ${colors.fg.tertiary} ${colors.bg.surface} ${colors.bg.surface}
    client.urgent           ${colors.red.mid}   ${colors.red.mid}  ${colors.fg.primary} ${colors.red.mid}   ${colors.red.mid}
    client.placeholder      ${colors.bg.base}   ${colors.bg.base}  ${colors.fg.quaternary} ${colors.bg.base} ${colors.bg.base}
    client.background       ${colors.bg.base}
  '';
  
  # Generate Polybar colors
  polybarConfig = fileFromTemplate "${themeName}-polybar-colors.ini" ''
    ; ${themeName} Polybar colors
    
    [colors]
    background = ${colors.bg.base}
    background-alt = ${colors.bg.surface}
    foreground = ${colors.fg.primary}
    foreground-alt = ${colors.fg.tertiary}
    primary = ${colors.blue.brightest}
    secondary = ${colors.purple.bright}
    alert = ${colors.red.mid}
  '';
  
  # Generate Rofi theme
  rofiTheme = fileFromTemplate "${themeName}-rofi.rasi" ''
    /* ${themeName} Rofi theme */
    
    * {
      bg-color: ${colors.bg.base};
      bg-alt-color: ${colors.bg.surface};
      fg-color: ${colors.fg.primary};
      fg-alt-color: ${colors.fg.tertiary};
      
      selected-bg-color: ${colors.blue.deep};
      selected-fg-color: ${colors.fg.primary};
      
      border-color: ${colors.blue.mid};
      
      background-color: @bg-color;
      text-color: @fg-color;
    }
    
    window {
      background-color: @bg-color;
      border: 2px;
      border-color: @border-color;
      border-radius: 8px;
      padding: 20px;
      width: 40%;
    }
    
    element selected.normal {
      background-color: @selected-bg-color;
      text-color: @selected-fg-color;
    }
  '';
  
  # Create a derivation that combines all themes
  themesDrv = pkgs.symlinkJoin {
    name = "${themeName}-themes";
    paths = [
      emacsTheme
      nvimTheme
      nvimLuaTheme
      tmuxTheme
      starshipConfig
      dircolorsConfig
      alacrittyConfig
      i3Config
      polybarConfig
      rofiTheme
    ];
  };
  
  # Install script
  installScript = pkgs.writeScriptBin "install-${themeName}-theme" ''
    #!/usr/bin/env bash
    
    THEME_NAME="${themeName}"
    DEST_DIR="$HOME/.config/$THEME_NAME"
    
    mkdir -p "$DEST_DIR"
    mkdir -p "$HOME/.config/nvim/colors"
    mkdir -p "$HOME/.config/alacritty"
    mkdir -p "$HOME/.config/tmux"
    
    # Copy theme files
    cp $themeName-theme.el "$HOME/.config/emacs/themes/"
    cp $themeName.vim "$HOME/.config/nvim/colors/"
    cp $themeName.lua "$HOME/.config/nvim/colors/"
    cp $themeName-alacritty.yml "$HOME/.config/alacritty/"
    
    echo "$THEME_NAME theme has been installed!"
  '';
in
pkgs.buildEnv {
  name = "${themeName}-theme-package";
  paths = [
    themesDrv
    installScript
  ];
}
EOF

# -----------------------------------------------------
# Fix 2: Patching the theme-module.nix file to fix Nix errors
# -----------------------------------------------------
echo "Patching nixos-theme-module.nix to fix Nix errors..."

cp /path/to/nixos-theme-module.nix "$TEMP_DIR/ono-sendai/nixos-theme-module.nix"

# Fix incorrect mkIf usage in home-manager section
sed -i 's/programs.tmux = mkIf cfg.applications.tmux {/programs.tmux = lib.mkIf cfg.applications.tmux {/g' "$TEMP_DIR/ono-sendai/nixos-theme-module.nix"
sed -i 's/programs.neovim = mkIf cfg.applications.neovim {/programs.neovim = lib.mkIf cfg.applications.neovim {/g' "$TEMP_DIR/ono-sendai/nixos-theme-module.nix"
sed -i 's/programs.emacs = mkIf cfg.applications.emacs {/programs.emacs = lib.mkIf cfg.applications.emacs {/g' "$TEMP_DIR/ono-sendai/nixos-theme-module.nix"
sed -i 's/programs.starship = mkIf cfg.applications.starship {/programs.starship = lib.mkIf cfg.applications.starship {/g' "$TEMP_DIR/ono-sendai/nixos-theme-module.nix"
sed -i 's/programs.dircolors = mkIf cfg.applications.dircolors {/programs.dircolors = lib.mkIf cfg.applications.dircolors {/g' "$TEMP_DIR/ono-sendai/nixos-theme-module.nix"
sed -i 's/xdg.configFile = mkIf cfg.applications.ghostty {/xdg.configFile = lib.mkIf cfg.applications.ghostty {/g' "$TEMP_DIR/ono-sendai/nixos-theme-module.nix"

# -----------------------------------------------------
# Fix 3: Create fixed configuration.nix
# -----------------------------------------------------
echo "Creating fixed configuration.nix..."

cat > "$TEMP_DIR/configuration.nix" << 'EOF'
{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./ono-sendai/nixos-theme-module.nix
    ./ono-sendai/nixos-fonts-config.nix
  ];

  # Enable flakes and other experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the Ono-Sendai theme
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
      starship = true;
      dircolors = true;
    };
  };

  # Basic system configuration
  networking.hostName = "ono-sendai";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles"; # Adjust to your timezone

  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Window manager & desktop environment setup
  services.xserver = {
    enable = true;
    
    # Use Xorg for better compatibility
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };
    
    # Enable i3 window manager with gaps
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3lock-fancy
        i3status-rust
        rofi
        dunst
        xss-lock
        arandr
        polybar
      ];
    };
    
    # Configure keyboard
    layout = "us";
    
    # Enable touchpad support
    libinput.enable = true;
  };

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Install and configure common packages
  environment.systemPackages = with pkgs; [
    # System utilities
    wget curl git htop
    
    # Terminal and shell
    alacritty tmux starship
    
    # Text editors
    neovim
    
    # GUI applications
    firefox
    
    # Development tools
    gcc gnumake
    
    # Window manager utilities
    polybar feh
    rofi dunst
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define user account
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    initialPassword = "nixos";
    shell = pkgs.bash;
  };

  # Enable Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nixos = { pkgs, ... }: {
      # Home Manager configuration
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.11";
}
EOF

# -----------------------------------------------------
# Fix 4: Create a valid flake.nix
# -----------------------------------------------------
echo "Creating fixed flake.nix..."

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
          }
        ];
      };
    };
}
EOF

# -----------------------------------------------------
# Fix 5: Copy the fixed fonts config
# -----------------------------------------------------
echo "Copying fonts configuration..."

cp /path/to/nixos-fonts-config.nix "$TEMP_DIR/ono-sendai/"

# -----------------------------------------------------
# Fix 6: Create installation script
# -----------------------------------------------------
echo "Creating installation script..."

cat > "$TEMP_DIR/install-ono-sendai.sh" << 'EOF'
#!/usr/bin/env bash
set -eo pipefail

DEST_DIR="/etc/nixos"
THEME_DIR="$DEST_DIR/ono-sendai"

echo "============================================================"
echo "       Installing Ono-Sendai NixOS Theme"
echo "============================================================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script needs root privileges to install system components."
  echo "Please run with sudo or as root."
  exit 1
fi

# Backup existing configuration
echo "Backing up existing NixOS configuration..."
if [ -d "$DEST_DIR" ]; then
  BACKUP_DIR="$DEST_DIR.backup.$(date +%Y%m%d%H%M%S)"
  mkdir -p "$BACKUP_DIR"
  cp -r "$DEST_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
  echo "Backup created at $BACKUP_DIR"
fi

# Create theme directory
mkdir -p "$THEME_DIR"

# Copy fixed files
echo "Installing theme files..."
cp ono-sendai/*.nix "$THEME_DIR/"
cp configuration.nix "$DEST_DIR/"
cp flake.nix "$DEST_DIR/"

# Make sure we preserve hardware-configuration.nix
if [ ! -f "$DEST_DIR/hardware-configuration.nix" ]; then
  if [ -f "$BACKUP_DIR/hardware-configuration.nix" ]; then
    echo "Restoring hardware-configuration.nix from backup..."
    cp "$BACKUP_DIR/hardware-configuration.nix" "$DEST_DIR/"
  else
    echo "Warning: hardware-configuration.nix not found."
    echo "Attempting to generate it..."
    nixos-generate-config --root / --dir "$DEST_DIR"
  fi
fi

echo "Setting permissions..."
chmod -R 755 "$THEME_DIR"

echo "Installation complete!"
echo ""
echo "To apply the configuration, run:"
echo "  sudo nixos-rebuild switch --flake /etc/nixos#ono-sendai"
echo ""
echo "After rebooting, login with:"
echo "  Username: nixos"
echo "  Password: nixos"
echo ""
echo "IMPORTANT: Change your password after first login"
echo ""
echo "Would you like to apply the configuration now? (y/N)"
read -r APPLY_NOW

if [[ "$APPLY_NOW" =~ ^[Yy]$ ]]; then
  echo "Applying configuration..."
  nixos-rebuild switch --flake /etc/nixos#ono-sendai
  
  echo ""
  echo "Configuration applied! Reboot your system to complete the installation:"
  echo "  sudo reboot"
else
  echo "You can apply the configuration later with the command shown above."
fi
EOF

chmod +x "$TEMP_DIR/install-ono-sendai.sh"

# -----------------------------------------------------
# Run the installation
# -----------------------------------------------------
echo "Moving files to their destinations..."

# Create the system directory structure 
mkdir -p "$TEMP_DIR/ono-sendai"

# Copy all the files to the temporary directory
echo "Preparing installation files..."

# Execute the installation script
echo "Running installation script..."
"$TEMP_DIR/install-ono-sendai.sh"

echo "============================================================"
echo "       Ono-Sendai Theme Installation Completed"
echo "============================================================"
echo ""
echo "Remember to reboot your system to apply all changes!"
