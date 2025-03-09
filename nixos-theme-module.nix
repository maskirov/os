{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.themes.ono-sendai;
in {
  options.themes.ono-sendai = {
    enable = mkEnableOption "Enable the Ono-Sendai cyberpunk theme";
    
    themeName = mkOption {
      type = types.str;
      default = "ono-sendai";
      description = "Name of the theme";
    };
    
    shortName = mkOption {
      type = types.str;
      default = "os";
      description = "Short name of the theme, used in some configurations";
    };
    
    applications = mkOption {
      type = types.submodule {
        options = {
          i3 = mkEnableOption "Apply theme to i3";
          polybar = mkEnableOption "Apply theme to polybar";
          tmux = mkEnableOption "Apply theme to tmux";
          alacritty = mkEnableOption "Apply theme to alacritty";
          neovim = mkEnableOption "Apply theme to neovim";
          emacs = mkEnableOption "Apply theme to emacs";
          rofi = mkEnableOption "Apply theme to rofi";
          ghostty = mkEnableOption "Apply theme to ghostty";
          starship = mkEnableOption "Apply theme to starship";
          dircolors = mkEnableOption "Apply theme to dircolors";
        };
      };
      default = {
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
      description = "Applications to apply the theme to";
    };
  };
  
  config = mkIf cfg.enable {
    # Create the theme package
    nixpkgs.overlays = [
      (self: super: {
        ono-sendai-theme = import ./theme-generator.nix { 
          pkgs = super; 
          lib = super.lib;
          themeName = cfg.themeName;
          themeShortName = cfg.shortName;
        };
      })
    ];
    
    # Install the theme package
    environment.systemPackages = [ pkgs.ono-sendai-theme ];
    
    # Configure applications with the theme
    
    # i3 configuration
    services.xserver.windowManager.i3 = mkIf cfg.applications.i3 {
      extraConfig = ''
        include ${pkgs.ono-sendai-theme}/share/i3/${cfg.themeName}-i3-colors
      '';
    };
    
    # Polybar
    services.polybar = mkIf cfg.applications.polybar {
      config = ''
        include-file = ${pkgs.ono-sendai-theme}/share/polybar/${cfg.themeName}-polybar-colors.ini
      '';
    };
    
    # Set up Alacritty theme
    programs.alacritty = mkIf cfg.applications.alacritty {
      settings = {
        import = [ "${cfg.themeName}.yml" ];
      };
    };
    
    # Set up Rofi theme
    programs.rofi = mkIf cfg.applications.rofi {
      theme = "${cfg.themeName}";
    };
    
    # Home-manager integrations (could be configured directly here or via home-manager)
    home-manager.users.nixos = { pkgs, lib, ... }: {
      # Tmux theme
      programs.tmux = lib.mkIf cfg.applications.tmux {
        extraConfig = ''
          source-file ${pkgs.ono-sendai-theme}/share/tmux/${cfg.themeName}-tmux.conf
        '';
      };
      
      # Neovim theme
      programs.neovim = lib.mkIf cfg.applications.neovim {
        plugins = with pkgs.vimPlugins; [
          {
            plugin = pkgs.vimUtils.buildVimPlugin {
              name = "ono-sendai-theme";
              src = pkgs.runCommand "ono-sendai-nvim-theme" {} ''
                mkdir -p $out/colors
                cp ${pkgs.ono-sendai-theme}/share/vim/vimfiles/colors/${cfg.themeName}.vim $out/colors/
                cp ${pkgs.ono-sendai-theme}/share/vim/vimfiles/colors/${cfg.themeName}.lua $out/colors/
              '';
            };
            config = ''
              colorscheme ${cfg.themeName}
            '';
          }
        ];
      };
      
      # Emacs theme
      programs.emacs = lib.mkIf cfg.applications.emacs {
        extraConfig = ''
          (add-to-list 'custom-theme-load-path "${pkgs.ono-sendai-theme}/share/emacs/site-lisp")
          (load-theme '${cfg.themeName} t)
        '';
      };
      
      # Starship theme
      programs.starship = lib.mkIf cfg.applications.starship {
        settings = builtins.fromTOML (builtins.readFile "${pkgs.ono-sendai-theme}/share/starship/${cfg.themeName}-starship.toml");
      };
      
      # Dircolors
      programs.dircolors = lib.mkIf cfg.applications.dircolors {
        enable = true;
        settings = builtins.fromString (builtins.readFile "${pkgs.ono-sendai-theme}/share/dircolors/${cfg.themeName}.dircolors");
      };
      
      # Ghostty
      xdg.configFile = lib.mkIf cfg.applications.ghostty {
        "ghostty/themes/${cfg.themeName}.conf".source = "${pkgs.ono-sendai-theme}/share/ghostty/${cfg.themeName}-ghostty.conf";
      };
    };
    
    # Add activation script that runs once after build
    system.userActivationScripts.ono-sendai-theme = ''
      # Create theme directories
      mkdir -p "$HOME/.config/${cfg.themeName}"
      mkdir -p "$HOME/.config/nvim/colors"
      mkdir -p "$HOME/.emacs.d/themes"
      mkdir -p "$HOME/.config/alacritty"
      mkdir -p "$HOME/.config/rofi"
      mkdir -p "$HOME/.config/tmux"
      mkdir -p "$HOME/.config/starship"
      mkdir -p "$HOME/.config/i3"
      mkdir -p "$HOME/.config/polybar"
      mkdir -p "$HOME/.config/ghostty"
      
      # Copy theme files
      ${pkgs.ono-sendai-theme}/bin/install-${cfg.themeName}-theme
      
      # Apply theme
      if [ -f "$HOME/.config/${cfg.themeName}/activate.sh" ]; then
        echo "Activating ${cfg.themeName} theme..."
        "$HOME/.config/${cfg.themeName}/activate.sh"
      fi
    '';
  };
}
