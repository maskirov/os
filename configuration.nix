{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./theme-module.nix      # The theme module we created
  ];

  # Enable flakes and other experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Optimize for Apple Silicon / UTM
  boot.kernelParams = [ "console=ttyAMA0" ];
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

  # Enable optimized VM settings
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Enable shared folders between host and VM
  fileSystems."/mnt/shared" = {
    device = "shared";
    fsType = "9p";
    options = [ "trans=virtio" "version=9p2000.L" "cache=loose" ];
    autoMount = true;
  };

  # Basic system configuration
  networking.hostName = "nixos-utm";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles"; # Adjust to your timezone

  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

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
      ghostty = true;
      starship = true;
      dircolors = true;
    };
  };

  # Window manager & desktop environment setup
  services.xserver = {
    enable = true;
    
    # Use Xorg for better compatibility
    displayManager = {
      lightdm.enable = true;
      lightdm.greeters.mini = {
        enable = true;
        user = "nixos";
        extraConfig = ''
          [greeter]
          show-password-label = false
          show-input-cursor = false
          password-alignment = center
          
          [greeter-theme]
          background-color = "#101216"
          text-color = "#E2E4E8"
          error-color = "#F85149"
          window-color = "#161B22"
          border-color = "#388BFD"
          password-color = "#E2E4E8"
          password-background-color = "#161B22"
        '';
      };
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

  # Configure picom compositor for nice effects
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    shadow = true;
    shadowOpacity = 0.75;
    shadowOffsets = [ (-7) (-7) ];
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    opacityRules = [
      "85:class_g = 'Alacritty' && focused"
      "75:class_g = 'Alacritty' && !focused"
    ];
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
      corner-radius = 12;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
    };
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

  # Configure fonts
  fonts = {
    enableDefaultPackages = true;
    
    # Font packages to install
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # Fallback until Berkeley Mono is setup
      inter
      ibm-plex
      font-awesome
      material-design-icons
      material-symbols
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      ubuntu_font_family
      dejavu_fonts
      liberation_ttf
      source-code-pro
      fira-code
      fira-code-symbols
    ];
    
    # Configure fontconfig
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Berkeley Mono" "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
        sansSerif = [ "Inter" "DejaVu Sans" ];
        serif = [ "IBM Plex Serif" "DejaVu Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
      
      # Font substitutions
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <!-- Ligature settings for Berkeley Mono Font -->
          <match target="font">
            <test name="family">
              <string>Berkeley Mono</string>
            </test>
            <edit name="fontfeatures" mode="append">
              <string>liga on</string>
              <string>dlig on</string>
            </edit>
          </match>
          
          <!-- Improve rendering -->
          <match target="font">
            <edit name="antialias" mode="assign">
              <bool>true</bool>
            </edit>
            <edit name="hinting" mode="assign">
              <bool>true</bool>
            </edit>
            <edit name="hintstyle" mode="assign">
              <const>hintslight</const>
            </edit>
            <edit name="lcdfilter" mode="assign">
              <const>lcddefault</const>
            </edit>
            <edit name="rgba" mode="assign">
              <const>rgb</const>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };

  # Install and configure common packages
  environment.systemPackages = with pkgs; [
    # System utilities
    wget curl git htop neofetch
    
    # Terminal and shell
    alacritty tmux starship
    
    # Text editors
    emacs neovim
    
    # GUI applications
    brave
    
    # Development tools
    gcc gnumake cmake
    python3 nodejs
    
    # Window manager utilities
    polybar feh picom
    rofi dunst
    
    # CLI tools
    ripgrep fd bat exa fzf jq
    
    # Theme-related
    lxappearance gtk-engine-murrine
    papirus-icon-theme
    
    # Utilities
    flameshot playerctl
    
    # Cloud storage
    rclone
  ];

  # Install nvchad
  system.userActivationScripts = {
    installNvchad = ''
      if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
      fi
    '';
  };

  # Configure systemd services
  systemd.user.services.polybar = {
    enable = true;
    description = "Polybar status bar";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${pkgs.polybar}/bin/polybar main";
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 2;
    };
  };

  # Video acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Configure GTK/Qt theming
  programs.dconf.enable = true;
  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };
  
  # Allow unfree packages (like Brave browser)
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
      # User-specific packages
      home.packages = with pkgs; [
        # Development tools
        gh
        devenv
        lazydocker
        lazygit
        
        # CLI tools
        ranger
        zoxide
        nnn
        btop
        
        # Media
        mpv
        vlc
        
        # Other
        obsidian
        keepassxc
      ];
      
      # Alacritty config
      programs.alacritty = {
        enable = true;
        settings = {
          font = {
            normal = {
              family = "Berkeley Mono";
              style = "Regular";
            };
            bold = {
              family = "Berkeley Mono";
              style = "Bold";
            };
            italic = {
              family = "Berkeley Mono";
              style = "Italic";
            };
            size = 13.0;
          };
          
          window = {
            padding = {
              x = 15;
              y = 15;
            };
            decorations = "none";
            opacity = 0.95;
          };
        };
      };
      
      # Configure bash shell
      programs.bash = {
        enable = true;
        enableCompletion = true;
        
        # Shell aliases
        shellAliases = {
          ll = "exa -la --icons";
          ls = "exa --icons";
          cat = "bat";
          find = "fd";
          grep = "rg";
          ".." = "cd ..";
          "..." = "cd ../..";
          
          # Git shortcuts
          gs = "git status";
          gd = "git diff";
          ga = "git add";
          gc = "git commit";
          gp = "git push";
          gl = "git pull";
          glog = "git log --oneline --graph";
          
          # System shortcuts
          sysupdate = "sudo nixos-rebuild switch --flake .#nixos-utm";
          homeupdate = "home-manager switch";
          
          # Tmux
          t = "tmux";
          ta = "tmux attach";
          tn = "tmux new-session -s";
        };
        
        # Add to bashrc
        bashrcExtra = ''
          # Initialize starship prompt
          eval "$(starship init bash)"
          
          # Initialize zoxide
          eval "$(zoxide init bash)"
          
          # Set editor
          export EDITOR=nvim
          export VISUAL=nvim
          
          # Local bin
          export PATH="$HOME/.local/bin:$PATH"
          
          # Add welcome message
          echo ""
          neofetch --disable gpu resolution packages shell wm de --colors 4 4 4 4 4 7
          echo ""
        '';
      };
      
      # Configure tmux
      programs.tmux = {
        enable = true;
        shortcut = "a";
        keyMode = "vi";
        customPaneNavigationAndResize = true;
        escapeTime = 0;
        aggressiveResize = true;
        baseIndex = 1;
        historyLimit = 100000;
      };
      
      # Configure Git
      programs.git = {
        enable = true;
        userName = "Your Name";
        userEmail = "your.email@example.com";
        
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = false;
          core.editor = "nvim";
          diff.colorMoved = "default";
        };
        
        delta = {
          enable = true;
          options = {
            navigate = true;
            line-numbers = true;
            syntax-theme = "Nord";
          };
        };
      };
      
      # Direnv for directory environments
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      
      # Let Home Manager install and manage itself
      programs.home-manager.enable = true;
      
      # State version
      home.stateVersion = "23.11";
    };
  };

  system.stateVersion = "23.11";
}
