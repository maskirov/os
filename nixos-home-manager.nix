{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # State version
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Packages to install
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

  # Alacritty terminal configuration
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      
      window = {
        padding = {
          x = 15;
          y = 15;
        };
        decorations = "none";
        opacity = 0.95;
        dynamic_title = true;
      };
      
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
        
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };
      
      # Nord theme
      colors = {
        primary = {
          background = "0x2E3440";
          foreground = "0xD8DEE9";
        };
        cursor = {
          text = "0x2E3440";
          cursor = "0xD8DEE9";
        };
        normal = {
          black = "0x3B4252";
          red = "0xBF616A";
          green = "0xA3BE8C";
          yellow = "0xEBCB8B";
          blue = "0x81A1C1";
          magenta = "0xB48EAD";
          cyan = "0x88C0D0";
          white = "0xE5E9F0";
        };
        bright = {
          black = "0x4C566A";
          red = "0xBF616A";
          green = "0xA3BE8C";
          yellow = "0xEBCB8B";
          blue = "0x81A1C1";
          magenta = "0xB48EAD";
          cyan = "0x8FBCBB";
          white = "0xECEFF4";
        };
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

  # Configure starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      
      directory = {
        style = "blue";
        truncation_length = 3;
      };
      
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "purple";
      };
      
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "purple";
      };
      
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
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
    
    extraConfig = ''
      # Enable mouse support
      set -g mouse on
      
      # True color support
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      
      # Automatically renumber windows
      set -g renumber-windows on
      
      # Status bar customization
      set -g status-style bg=default
      set -g status-left "#[fg=blue,bold]#S #[fg=white,nobold]| "
      set -g status-left-length 20
      set -g status-right "#[fg=blue,bold]%H:%M #[fg=white,nobold]| #[fg=blue,bold]%d-%b-%y"
      set -g status-right-length 40
      set -g window-status-format "#[fg=white]#I:#W"
      set -g window-status-current-format "#[fg=green,bold]#I:#W"
      
      # Split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Reload config file
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
    '';
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # We're using NvChad, so minimal config here
    extraConfig = ''
      " Basic settings
      set number
      set relativenumber
      set clipboard+=unnamedplus
      
      " Berkeley Mono ligature support
      set guifont=Berkeley\ Mono:h13
    '';
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

  # Configure rofi application launcher
  programs.rofi = {
    enable = true;
    font = "Berkeley Mono 12";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "nord";
    extraConfig = {
      modi = "drun,run,window,ssh";
      icon-theme = "Papirus";
      show-icons = true;
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = true;
    };
  };

  # Direnv for directory environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Create default i3 configuration
  xdg.configFile."i3/config".text = ''
    # i3 config file (v4)
    # Please see http://i3wm.org/docs/userguide.html for a complete reference!

    set $mod Mod4

    # Font for window titles
    font pango:Berkeley Mono 10

    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod

    # Start a terminal
    bindsym $mod+Return exec alacritty

    # Kill focused window
    bindsym $mod+Shift+q kill

    # Start rofi (application launcher)
    bindsym $mod+d exec --no-startup-id rofi -show drun
    bindsym $mod+Tab exec --no-startup-id rofi -show window

    # Change focus
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    # Move focused window
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # Split in horizontal orientation
    bindsym $mod+b split h

    # Split in vertical orientation
    bindsym $mod+v split v

    # Enter fullscreen mode for the focused container
    bindsym $mod+f fullscreen toggle

    # Change container layout (stacked, tabbed, toggle split)
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Toggle tiling / floating
    bindsym $mod+Shift+space floating toggle

    # Change focus between tiling / floating windows
    bindsym $mod+space focus mode_toggle

    # Focus the parent container
    bindsym $mod+a focus parent

    # Define names for default workspaces
    set $ws1 "1:  term"
    set $ws2 "2:  web"
    set $ws3 "3:  code"
    set $ws4 "4:  files"
    set $ws5 "5:  chat"
    set $ws6 "6:  media"
    set $ws7 "7:  sys"
    set $ws8 "8:  misc"
    set $ws9 "9:  misc"
    set $ws10 "10:  misc"

    # Switch to workspace
    bindsym $mod+1 workspace $ws1
    bindsym $mod+2 workspace $ws2
    bindsym $mod+3 workspace $ws3
    bindsym $mod+4 workspace $ws4
    bindsym $mod+5 workspace $ws5
    bindsym $mod+6 workspace $ws6
    bindsym $mod+7 workspace $ws7
    bindsym $mod+8 workspace $ws8
    bindsym $mod+9 workspace $ws9
    bindsym $mod+0 workspace $ws10

    # Move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace $ws1
    bindsym $mod+Shift+2 move container to workspace $ws2
    bindsym $mod+Shift+3 move container to workspace $ws3
    bindsym $mod+Shift+4 move container to workspace $ws4
    bindsym $mod+Shift+5 move container to workspace $ws5
    bindsym $mod+Shift+6 move container to workspace $ws6
    bindsym $mod+Shift+7 move container to workspace $ws7
    bindsym $mod+Shift+8 move container to workspace $ws8
    bindsym $mod+Shift+9 move container to workspace $ws9
    bindsym $mod+Shift+0 move container to workspace $ws10

    # Reload the configuration file
    bindsym $mod+Shift+c reload
    # Restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
    bindsym $mod+Shift+r restart
    # Exit i3 (logs you out of your X session)
    bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

    # Resize window (you can also use the mouse for that)
    mode "resize" {
            bindsym h resize shrink width 10 px or 10 ppt
            bindsym j resize grow height 10 px or 10 ppt
            bindsym k resize shrink height 10 px or 10 ppt
            bindsym l resize grow width 10 px or 10 ppt

            # Back to normal: Enter or Escape or $mod+r
            bindsym Return mode "default"
            bindsym Escape mode "default"
            bindsym $mod+r mode "default"
    }

    bindsym $mod+r mode "resize"

    # Window colors
    # class                 border  backgr. text    indicator child_border
    client.focused          #81a1c1 #81a1c1 #ffffff #5e81ac   #81a1c1
    client.focused_inactive #4c566a #4c566a #ffffff #4c566a   #4c566a
    client.unfocused        #2e3440 #2e3440 #888888 #2e3440   #2e3440
    client.urgent           #bf616a #bf616a #ffffff #bf616a   #bf616a
    client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c
    client.background       #ffffff

    # i3-gaps settings
    gaps inner 12
    gaps outer 0
    smart_gaps on
    smart_borders on

    # Rounded borders
    border_radius 8

    # Remove window title bar
    default_border pixel 2
    default_floating_border pixel 2
    hide_edge_borders smart

    # Autostart applications
    exec --no-startup-id picom --experimental-backends
    exec --no-startup-id feh --randomize --bg-fill ~/wallpapers/*
    exec --no-startup-id polybar main
    exec --no-startup-id dunst
    exec --no-startup-id nm-applet
    exec --no-startup-id xss-lock -- i3lock-fancy

    # Lock screen
    bindsym $mod+Shift+x exec i3lock-fancy

    # Screenshots
    bindsym Print exec --no-startup-id flameshot gui

    # Media controls
    bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%
    bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%
    bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle
    bindsym XF86AudioPlay exec --no-startup-id playerctl play-pause
    bindsym XF86AudioNext exec --no-startup-id playerctl next
    bindsym XF86AudioPrev exec --no-startup-id playerctl previous

    # Application specific settings
    for_window [class="Brave-browser"] move to workspace $ws2
    for_window [class="code-oss"] move to workspace $ws3
    for_window [class="Emacs"] move to workspace $ws3
    for_window [class="Thunar"] move to workspace $ws4
    for_window [class="discord"] move to workspace $ws5
    for_window [class="Spotify"] move to workspace $ws6
    
    # Floating windows
    for_window [class="Pavucontrol"] floating enable
    for_window [class="Lxappearance"] floating enable
    for_window [class="Arandr"] floating enable
  '';

  # Configure polybar
  xdg.configFile."polybar/config.ini".text = ''
    [colors]
    background = #2E3440
    background-alt = #3B4252
    foreground = #ECEFF4
    foreground-alt = #E5E9F0
    primary = #88C0D0
    secondary = #5E81AC
    alert = #BF616A
    disabled = #707880

    [bar/main]
    width = 100%
    height = 32
    radius = 8
    fixed-center = true

    background = ${colors.background}
    foreground = ${colors.foreground}

    line-size = 2

    border-size = 8
    border-color = #00000000

    padding-left = 2
    padding-right = 2

    module-margin-left = 1
    module-margin-right = 1

    font-0 = "Berkeley Mono:style=Regular:pixelsize=11;2"
    font-1 = "Font Awesome 6 Free:style=Regular:pixelsize=11;2"
    font-2 = "Font Awesome 6 Free:style=Solid:pixelsize=11;2"
    font-3 = "Font Awesome 6 Brands:pixelsize=11;2"
    font-4 = "Material Icons:pixelsize=13;4"

    modules-left = i3 xwindow
    modules-center = date
    modules-right = filesystem pulseaudio memory cpu wlan eth battery

    tray-position = right
    tray-padding = 2

    cursor-click = pointer
    cursor-scroll