{ pkgs ? import <nixpkgs> {}, 
  lib ? pkgs.lib,
  themeName ? "ono-sendai",
  themeShortName ? "os",
  extraThemeInfo ? {},
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
  
  # Generate Emacs theme
  emacsTheme = fileFromTemplate "${themeName}-theme.el" ''
    ;;; ${themeName}-theme.el --- A cyberpunk color theme for Emacs -*- lexical-binding: t -*-

    ;; Author: Generated from Nix
    ;; Version: 1.0.0
    ;; Keywords: faces
    ;; Package-Requires: ((emacs "24.1") (autothemer "0.2"))

    ;; This file is not part of GNU Emacs.

    ;;; Commentary:
    ;; A dark cyberpunk theme inspired by Ono-Sendai aesthetics

    ;;; Code:
    (require 'autothemer)

    (autothemer-deftheme
     ${themeName} "A cyberpunk interface for elite hackers"

     ((((class color) (min-colors #xFFFFFF))
       ((class color) (min-colors #xFF)))

      ;; Define colors
      (bg-base           "${colors.bg.base}" nil)
      (bg-surface        "${colors.bg.surface}" nil)
      (bg-elevated       "${colors.bg.elevated}" nil)
      (bg-border         "${colors.bg.border}" nil)
      (bg-highlight      "${colors.bg.highlight}" nil)

      (fg-primary        "${colors.fg.primary}" nil)
      (fg-secondary      "${colors.fg.secondary}" nil)
      (fg-tertiary       "${colors.fg.tertiary}" nil)
      (fg-quaternary     "${colors.fg.quaternary}" nil)
      (fg-quinary        "${colors.fg.quinary}" nil)
      
      (blue-brightest    "${colors.blue.brightest}" nil)
      (blue-bright       "${colors.blue.bright}" nil)
      (blue-mid          "${colors.blue.mid}" nil)
      (blue-deep         "${colors.blue.deep}" nil)
      (blue-darkest      "${colors.blue.darkest}" nil)
      
      (purple-brightest  "${colors.purple.brightest}" nil)
      (purple-bright     "${colors.purple.bright}" nil)
      (purple-mid        "${colors.purple.mid}" nil)
      (purple-deep       "${colors.purple.deep}" nil)
      (purple-darkest    "${colors.purple.darkest}" nil)
      
      (green-lightest    "${colors.green.lightest}" nil)
      (green-light       "${colors.green.light}" nil)
      (green-mid         "${colors.green.mid}" nil)
      (green-deep        "${colors.green.deep}" nil)
      (green-darkest     "${colors.green.darkest}" nil)
      
      (orange-light      "${colors.orange.light}" nil)
      (orange-mid        "${colors.orange.mid}" nil)
      (orange-deep       "${colors.orange.deep}" nil)
      (orange-burnt      "${colors.orange.burnt}" nil)
      (orange-darkest    "${colors.orange.darkest}" nil)
      
      (red-light         "${colors.red.light}" nil)
      (red-mid           "${colors.red.mid}" nil)
      (red-deep          "${colors.red.deep}" nil)
      (red-dark          "${colors.red.dark}" nil)
      (red-darkest       "${colors.red.darkest}" nil)
      
      (cyan-light        "${colors.cyan.light}" nil)
      (cyan-mid          "${colors.cyan.mid}" nil)
      (cyan-deep         "${colors.cyan.deep}" nil)
      (cyan-dark         "${colors.cyan.dark}" nil)
      (cyan-darkest      "${colors.cyan.darkest}" nil)

      (ansi-black        "${colors.ansi.black}" nil)
      (ansi-red          "${colors.ansi.red}" nil)
      (ansi-green        "${colors.ansi.green}" nil)
      (ansi-yellow       "${colors.ansi.yellow}" nil)
      (ansi-blue         "${colors.ansi.blue}" nil)
      (ansi-magenta      "${colors.ansi.magenta}" nil)
      (ansi-cyan         "${colors.ansi.cyan}" nil)
      (ansi-white        "${colors.ansi.white}" nil)
      (ansi-bright-black "${colors.ansi.brightBlack}" nil)
      (ansi-bright-red   "${colors.ansi.brightRed}" nil)
      (ansi-bright-green "${colors.ansi.brightGreen}" nil)
      (ansi-bright-yellow "${colors.ansi.brightYellow}" nil)
      (ansi-bright-blue  "${colors.ansi.brightBlue}" nil)
      (ansi-bright-magenta "${colors.ansi.brightMagenta}" nil)
      (ansi-bright-cyan  "${colors.ansi.brightCyan}" nil)
      (ansi-bright-white "${colors.ansi.brightWhite}" nil))

     ;; Face customizations
     ((default                           (:background bg-base            :foreground fg-primary))
      (cursor                            (:background blue-brightest))
      (region                            (:background blue-deep))
      (highlight                         (:background bg-border))
      (hl-line                           (:background bg-surface))
      (fringe                            (:background bg-base))
      (minibuffer-prompt                 (:foreground blue-brightest))
      (vertical-border                   (:foreground bg-border))
      (window-divider                    (:foreground bg-border))
      (link                              (:foreground blue-brightest     :underline t))
      
      ;; Font lock
      (font-lock-builtin-face            (:foreground purple-bright))
      (font-lock-comment-face            (:foreground fg-tertiary))
      (font-lock-comment-delimiter-face  (:foreground fg-tertiary))
      (font-lock-constant-face           (:foreground cyan-mid))
      (font-lock-doc-face                (:foreground fg-quaternary))
      (font-lock-function-name-face      (:foreground blue-brightest))
      (font-lock-keyword-face            (:foreground purple-brightest))
      (font-lock-string-face             (:foreground green-light))
      (font-lock-type-face               (:foreground cyan-light))
      (font-lock-variable-name-face      (:foreground blue-bright))
      (font-lock-warning-face            (:foreground orange-mid))
      
      ;; Mode line
      (mode-line                         (:background bg-elevated        :foreground fg-primary))
      (mode-line-inactive                (:background bg-surface         :foreground fg-tertiary))
      
      ;; Line numbers
      (line-number                       (:background bg-base            :foreground fg-quaternary))
      (line-number-current-line          (:background bg-surface         :foreground fg-primary))
      
      ;; Search
      (isearch                           (:background blue-deep          :foreground fg-primary))
      (lazy-highlight                    (:background blue-darkest       :foreground fg-primary))
      
      ;; Company mode
      (company-tooltip                   (:background bg-surface         :foreground fg-primary))
      (company-tooltip-selection         (:background bg-elevated        :foreground fg-primary))
      (company-tooltip-common            (:foreground blue-brightest))
      (company-scrollbar-bg              (:background bg-border))
      (company-scrollbar-fg              (:background blue-mid))
      
      ;; Magit
      (magit-diff-added                  (:background nil                :foreground green-mid))
      (magit-diff-removed                (:background nil                :foreground red-mid))
      (magit-diff-hunk-heading           (:background bg-surface         :foreground fg-secondary))
      (magit-section-highlight           (:background bg-surface))
      (magit-section-heading             (:foreground blue-brightest     :weight 'bold))
      
      ;; Terminal Colors
      (term-color-black                  (:background ansi-black         :foreground ansi-black))
      (term-color-red                    (:background ansi-red           :foreground ansi-red))
      (term-color-green                  (:background ansi-green         :foreground ansi-green))
      (term-color-yellow                 (:background ansi-yellow        :foreground ansi-yellow))
      (term-color-blue                   (:background ansi-blue          :foreground ansi-blue))
      (term-color-magenta                (:background ansi-magenta       :foreground ansi-magenta))
      (term-color-cyan                   (:background ansi-cyan          :foreground ansi-cyan))
      (term-color-white                  (:background ansi-white         :foreground ansi-white))

      ;; Ansi colors for term and vterm
      (ansi-color-black                  (:background ansi-black         :foreground ansi-black))
      (ansi-color-red                    (:background ansi-red           :foreground ansi-red))
      (ansi-color-green                  (:background ansi-green         :foreground ansi-green))
      (ansi-color-yellow                 (:background ansi-yellow        :foreground ansi-yellow))
      (ansi-color-blue                   (:background ansi-blue          :foreground ansi-blue))
      (ansi-color-magenta                (:background ansi-magenta       :foreground ansi-magenta))
      (ansi-color-cyan                   (:background ansi-cyan          :foreground ansi-cyan))
      (ansi-color-white                  (:background ansi-white         :foreground ansi-white))
      
      (ansi-color-bright-black           (:background ansi-bright-black  :foreground ansi-bright-black))
      (ansi-color-bright-red             (:background ansi-bright-red    :foreground ansi-bright-red))
      (ansi-color-bright-green           (:background ansi-bright-green  :foreground ansi-bright-green))
      (ansi-color-bright-yellow          (:background ansi-bright-yellow :foreground ansi-bright-yellow))
      (ansi-color-bright-blue            (:background ansi-bright-blue   :foreground ansi-bright-blue))
      (ansi-color-bright-magenta         (:background ansi-bright-magenta :foreground ansi-bright-magenta))
      (ansi-color-bright-cyan            (:background ansi-bright-cyan   :foreground ansi-bright-cyan))
      (ansi-color-bright-white           (:background ansi-bright-white  :foreground ansi-bright-white))
      ))

    ;;;###autoload
    (when load-file-name
      (add-to-list
       'custom-theme-load-path
       (file-name-as-directory (file-name-directory load-file-name))))

    (provide-theme '${themeName})
    
    ;;; ${themeName}-theme.el ends here
  '';
  
  # Generate Neovim theme
  nvimTheme = fileFromTemplate "${themeName}.vim" ''
    " ${themeName}.vim - A cyberpunk interface for elite hackers
    " Maintainer: Generated from Nix
    " Version: 1.0
    
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
    hi Folded guifg=${colors.fg.tertiary} guibg=${colors.bg.surface}
    hi FoldColumn guifg=${colors.fg.tertiary} guibg=${colors.bg.base}
    hi SignColumn guibg=${colors.bg.base}
    hi IncSearch guifg=${colors.fg.primary} guibg=${colors.blue.deep}
    hi Search guifg=${colors.fg.primary} guibg=${colors.blue.darkest}
    hi Visual guibg=${colors.blue.deep}
    hi VisualNOS guibg=${colors.blue.deep}
    hi MatchParen guifg=${colors.blue.brightest} guibg=${colors.blue.deep}
    hi Pmenu guifg=${colors.fg.primary} guibg=${colors.bg.surface}
    hi PmenuSel guifg=${colors.fg.primary} guibg=${colors.bg.elevated}
    hi PmenuSbar guibg=${colors.bg.border}
    hi PmenuThumb guibg=${colors.blue.mid}
    hi StatusLine guifg=${colors.fg.primary} guibg=${colors.bg.elevated}
    hi StatusLineNC guifg=${colors.fg.tertiary} guibg=${colors.bg.surface}
    hi WildMenu guifg=${colors.fg.primary} guibg=${colors.blue.deep}
    
    " Syntax highlighting
    hi Comment guifg=${colors.fg.tertiary}
    hi Constant guifg=${colors.cyan.mid}
    hi String guifg=${colors.green.light}
    hi Number guifg=${colors.orange.mid}
    hi Identifier guifg=${colors.blue.bright}
    hi Function guifg=${colors.blue.brightest}
    hi Statement guifg=${colors.purple.brightest}
    hi Operator guifg=${colors.purple.bright}
    hi Keyword guifg=${colors.purple.bright}
    hi PreProc guifg=${colors.purple.brightest}
    hi Type guifg=${colors.cyan.light}
    hi Special guifg=${colors.orange.mid}
    hi Underlined guifg=${colors.blue.brightest} gui=underline
    hi Todo guifg=${colors.orange.light} guibg=NONE gui=bold
    hi Error guifg=${colors.red.mid} guibg=NONE gui=bold
    
    " Git highlighting
    hi DiffAdd guibg=${colors.green.darkest} guifg=${colors.green.light}
    hi DiffChange guibg=${colors.blue.darkest} guifg=${colors.fg.primary}
    hi DiffDelete guibg=${colors.red.darkest} guifg=${colors.red.light}
    hi DiffText guibg=${colors.blue.deep} guifg=${colors.fg.primary}
    
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
  
  # Generate Neovim Lua theme
  nvimLuaTheme = fileFromTemplate "${themeName}.lua" ''
    -- ${themeName}.lua - A cyberpunk interface for elite hackers
    
    local colors = {
      bg = {
        base = "${colors.bg.base}",
        surface = "${colors.bg.surface}",
        elevated = "${colors.bg.elevated}",
        border = "${colors.bg.border}",
        highlight = "${colors.bg.highlight}",
      },
      fg = {
        primary = "${colors.fg.primary}",
        secondary = "${colors.fg.secondary}",
        tertiary = "${colors.fg.tertiary}",
        quaternary = "${colors.fg.quaternary}",
        quinary = "${colors.fg.quinary}",
      },
      blue = {
        brightest = "${colors.blue.brightest}",
        bright = "${colors.blue.bright}",
        mid = "${colors.blue.mid}",
        deep = "${colors.blue.deep}",
        darkest = "${colors.blue.darkest}",
      },
      purple = {
        brightest = "${colors.purple.brightest}",
        bright = "${colors.purple.bright}",
        mid = "${colors.purple.mid}",
        deep = "${colors.purple.deep}",
        darkest = "${colors.purple.darkest}",
      },
      green = {
        lightest = "${colors.green.lightest}",
        light = "${colors.green.light}",
        mid = "${colors.green.mid}",
        deep = "${colors.green.deep}",
        darkest = "${colors.green.darkest}",
      },
      orange = {
        light = "${colors.orange.light}",
        mid = "${colors.orange.mid}",
        deep = "${colors.orange.deep}",
        burnt = "${colors.orange.burnt}",
        darkest = "${colors.orange.darkest}",
      },
      red = {
        light = "${colors.red.light}",
        mid = "${colors.red.mid}",
        deep = "${colors.red.deep}",
        dark = "${colors.red.dark}",
        darkest = "${colors.red.darkest}",
      },
      cyan = {
        light = "${colors.cyan.light}",
        mid = "${colors.cyan.mid}",
        deep = "${colors.cyan.deep}",
        dark = "${colors.cyan.dark}",
        darkest = "${colors.cyan.darkest}",
      },
      ansi = {
        black = "${colors.ansi.black}",
        red = "${colors.ansi.red}",
        green = "${colors.ansi.green}",
        yellow = "${colors.ansi.yellow}",
        blue = "${colors.ansi.blue}",
        magenta = "${colors.ansi.magenta}",
        cyan = "${colors.ansi.cyan}",
        white = "${colors.ansi.white}",
        brightBlack = "${colors.ansi.brightBlack}",
        brightRed = "${colors.ansi.brightRed}",
        brightGreen = "${colors.ansi.brightGreen}",
        brightYellow = "${colors.ansi.brightYellow}",
        brightBlue = "${colors.ansi.brightBlue}",
        brightMagenta = "${colors.ansi.brightMagenta}",
        brightCyan = "${colors.ansi.brightCyan}",
        brightWhite = "${colors.ansi.brightWhite}",
      },
    }
    
    local ${themeShortName} = {
      normal = {
        a = { fg = colors.bg.base, bg = colors.blue.brightest, gui = "bold" },
        b = { fg = colors.fg.primary, bg = colors.bg.elevated },
        c = { fg = colors.fg.tertiary, bg = colors.bg.surface },
      },
      insert = {
        a = { fg = colors.bg.base, bg = colors.green.mid, gui = "bold" },
      },
      visual = {
        a = { fg = colors.bg.base, bg = colors.purple.bright, gui = "bold" },
      },
      replace = {
        a = { fg = colors.bg.base, bg = colors.red.mid, gui = "bold" },
      },
      command = {
        a = { fg = colors.bg.base, bg = colors.orange.mid, gui = "bold" },
      },
      inactive = {
        a = { fg = colors.fg.tertiary, bg = colors.bg.surface, gui = "bold" },
        b = { fg = colors.fg.tertiary, bg = colors.bg.surface },
        c = { fg = colors.fg.tertiary, bg = colors.bg.surface },
      },
    }
    
    -- Setup for Lualine
    if vim.g.colors_name == "${themeName}" then
      local lualine_c = require("lualine.components")
      lualine_c.options = {
        theme = ${themeShortName},
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      }
    end
    
    -- Helper function to set highlight groups
    local function hi(group, opts)
      vim.api.nvim_set_hl(0, group, opts)
    end
    
    -- Apply highlights
    local function apply_highlights()
      -- UI elements
      hi("Normal", { fg = colors.fg.primary, bg = colors.bg.base })
      hi("Cursor", { fg = colors.bg.base, bg = colors.blue.brightest })
      hi("CursorLine", { bg = colors.bg.surface })
      hi("CursorLineNr", { fg = colors.fg.primary, bg = colors.bg.surface })
      hi("LineNr", { fg = colors.fg.quaternary, bg = colors.bg.base })
      
      -- More highlights here...
    end
    
    -- Apply the theme
    local function load_${themeShortName}()
      vim.cmd("hi clear")
      if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
      end
      vim.g.colors_name = "${themeName}"
      
      apply_highlights()
    end
    
    load_${themeShortName}()
    
    return ${themeShortName}
  '';

  # Generate Tmux theme
  tmuxTheme = fileFromTemplate "${themeName}-tmux.conf" ''
    # ${themeName} tmux theme
    # A cyberpunk interface for elite hackers
    
    # Status bar colors
    set -g status-style bg=${colors.bg.surface},fg=${colors.fg.primary}
    
    # Left and right status sections
    set -g status-left "#[fg=${colors.blue.brightest},bold] #S #[fg=${colors.fg.tertiary}]│ "
    set -g status-left-length 20
    set -g status-right "#[fg=${colors.orange.mid}]%H:%M #[fg=${colors.fg.tertiary}]│ #[fg=${colors.purple.bright}]%d-%b-%y "
    set -g status-right-length 40
    
    # Window status
    set -g window-status-format "#[fg=${colors.fg.tertiary}]#I:#W"
    set -g window-status-current-format "#[fg=${colors.blue.brightest},bold]#I:#W"
    
    # Pane borders
    set -g pane-border-style fg=${colors.bg.border}
    set -g pane-active-border-style fg=${colors.blue.mid}
    
    # Message text
    set -g message-style bg=${colors.bg.surface},fg=${colors.fg.primary}
  '';
  
  # Generate Starship prompt config
  starshipConfig = fileFromTemplate "${themeName}-starship.toml" ''
    # ${themeName} Starship prompt configuration
    # A cyberpunk interface for elite hackers
    
    format = """
    $username\
    $hostname\
    $directory\
    $git_branch\
    $git_state\
    $git_status\
    $cmd_duration\
    $line_break\
    $character"""
    
    # Prompt characters
    [character]
    success_symbol = "[➜](${colors.green.mid})"
    error_symbol = "[✗](${colors.red.mid})"
    
    # Username
    [username]
    style_user = "${colors.fg.primary}"
    style_root = "${colors.red.mid}"
    format = "[$user]($style) "
    show_always = false
    
    # Hostname
    [hostname]
    ssh_only = true
    format = "[@$hostname](${colors.orange.mid}) "
    
    # Directory
    [directory]
    style = "${colors.blue.brightest}"
    format = "[$path]($style) "
    truncation_length = 3
    truncation_symbol = "…/"
    
    # Git branch
    [git_branch]
    symbol = " "
    style = "${colors.purple.bright}"
    format = "[$symbol$branch]($style) "
    
    # Git status
    [git_status]
    style = "${colors.purple.bright}"
    format = '([\[$all_status$ahead_behind\]]($style) )'
    
    # Command duration
    [cmd_duration]
    min_time = 5000
    format = "took [$duration](${colors.orange.mid}) "
    
    # Language versions
    [python]
    format = '[${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'
    style = "${colors.green.mid}"
    
    [nodejs]
    format = '[${symbol}(${version} )]($style)'
    style = "${colors.green.mid}"
    
    [rust]
    format = '[${symbol}(${version} )]($style)'
    style = "${colors.orange.mid}"
    
    [golang]
    format = '[${symbol}(${version} )]($style)'
    style = "${colors.blue.brightest}"
  '';
  
  # Generate dircolors
  dircolorsConfig = fileFromTemplate "${themeName}.dircolors" ''
    # ${themeName} dircolors configuration
    # A cyberpunk interface for elite hackers
    
    # Default colors
    NORMAL 00
    FILE 00
    DIR 01;34
    LINK 01;36
    FIFO 40;33
    SOCK 01;35
    DOOR 01;35
    BLK 40;33;01
    CHR 40;33;01
    ORPHAN 40;31;01
    EXEC 01;32
    
    # Archives
    .tar 01;31
    .tgz 01;31
    .arc 01;31
    .arj 01;31
    .taz 01;31
    .lha 01;31
    .lz4 01;31
    .lzh 01;31
    .lzma 01;31
    .tlz 01;31
    .txz 01;31
    .tzo 01;31
    .t7z 01;31
    .zip 01;31
    .z 01;31
    .dz 01;31
    .gz 01;31
    .lrz 01;31
    .lz 01;31
    .lzo 01;31
    .xz 01;31
    .zst 01;31
    .tzst 01;31
    .bz2 01;31
    .bz 01;31
    .tbz 01;31
    .tbz2 01;31
    .tz 01;31
    .deb 01;31
    .rpm 01;31
    .jar 01;31
    .war 01;31
    .ear 01;31
    .sar 01;31
    .rar 01;31
    .alz 01;31
    .ace 01;31
    .zoo 01;31
    .cpio 01;31
    .7z 01;31
    .rz 01;31
    .cab 01;31
    
    # Image formats
    .jpg 01;35
    .jpeg 01;35
    .mjpg 01;35
    .mjpeg 01;35
    .gif 01;35
    .bmp 01;35
    .pbm 01;35
    .pgm 01;35
    .ppm 01;35
    .tga 01;35
    .xbm 01;35
    .xpm 01;35
    .tif 01;35
    .tiff 01;35
    .png 01;35
    .svg 01;35
    .svgz 01;35
    .mng 01;35
    .pcx 01;35
    .webp 01;35
    .ico 01;35
    
    # Video formats
    .mov 01;35
    .mpg 01;35
    .mpeg 01;35
    .m2v 01;35
    .mkv 01;35
    .webm 01;35
    .ogm 01;35
    .mp4 01;35
    .m4v 01;35
    .mp4v 01;35
    .vob 01;35
    .qt 01;35
    .nuv 01;35
    .wmv 01;35
    .asf 01;35
    .rm 01;35
    .rmvb 01;35
    .flc 01;35
    .avi 01;35
    .fli 01;35
    .flv 01;35
    .gl 01;35
    .dl 01;35
    .xcf 01;35
    .xwd 01;35
    .yuv 01;35
    .cgm 01;35
    .emf 01;35
    
    # Audio formats
    .aac 00;36
    .au 00;36
    .flac 00;36
    .m4a 00;36
    .mid 00;36
    .midi 00;36
    .mka 00;36
    .mp3 00;36
    .mpc 00;36
    .ogg 00;36
    .ra 00;36
    .wav 00;36
    .oga 00;36
    .opus 00;36
    .spx 00;36
    .xspf 00;36
  '';
  
  # Generate Ghostty config
  ghosttyConfig = fileFromTemplate "${themeName}-ghostty.conf" ''
    # ${themeName} Ghostty configuration
    # A cyberpunk interface for elite hackers
    
    # Background and foreground colors
    background = ${colors.bg.base}
    foreground = ${colors.fg.primary}
    
    # Normal colors
    palette = 0=${colors.ansi.black}
    palette = 1=${colors.ansi.red}
    palette = 2=${colors.ansi.green}
    palette = 3=${colors.ansi.yellow}
    palette = 4=${colors.ansi.blue}
    palette = 5=${colors.ansi.magenta}
    palette = 6=${colors.ansi.cyan}
    palette = 7=${colors.ansi.white}
    
    # Bright colors
    palette = 8=${colors.ansi.brightBlack}
    palette = 9=${colors.ansi.brightRed}
    palette = 10=${colors.ansi.brightGreen}
    palette = 11=${colors.ansi.brightYellow}
    palette = 12=${colors.ansi.brightBlue}
    palette = 13=${colors.ansi.brightMagenta}
    palette = 14=${colors.ansi.brightCyan}
    palette = 15=${colors.ansi.brightWhite}
    
    # Selection colors
    selection-background = ${colors.blue.deep}
    selection-foreground = ${colors.fg.primary}
    
    # UI settings
    window-theme = dark
    font-family = "Berkeley Mono"
    font-feature = "ss01"
    font-feature = "ss02"
    font-feature = "ss03"
    font-feature = "calt"
    font-feature = "liga"
    font-size = 13
    cursor-style = block
    cursor-color = ${colors.blue.brightest}
  '';
  
  # Generate i3 config colors
  i3Config = fileFromTemplate "${themeName}-i3-colors" ''
    # ${themeName} i3 colors
    # A cyberpunk interface for elite hackers
    
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
    ; A cyberpunk interface for elite hackers
    
    [colors]
    background = ${colors.bg.base}
    background-alt = ${colors.bg.surface}
    foreground = ${colors.fg.primary}
    foreground-alt = ${colors.fg.tertiary}
    primary = ${colors.blue.brightest}
    secondary = ${colors.purple.bright}
    alert = ${colors.red.mid}
    
    ; Module colors
    cpu = ${colors.cyan.mid}
    memory = ${colors.blue.brightest}
    temperature = ${colors.orange.mid}
    network = ${colors.green.mid}
    volume = ${colors.purple.bright}
    battery-full = ${colors.green.mid}
    battery-charging = ${colors.blue.brightest}
    battery-discharging = ${colors.orange.mid}
    battery-critical = ${colors.red.mid}
  '';
  
  # Generate Alacritty config
  alacrittyConfig = fileFromTemplate "${themeName}-alacritty.yml" ''
    # ${themeName} Alacritty configuration
    # A cyberpunk interface for elite hackers
    
    colors:
      # Default colors
      primary:
        background: '${colors.bg.base}'
        foreground: '${colors.fg.primary}'
      
      # Cursor colors
      cursor:
        text: '${colors.bg.base}'
        cursor: '${colors.blue.brightest}'
      
      # Selection colors
      selection:
        text: '${colors.fg.primary}'
        background: '${colors.blue.deep}'
      
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
  
  # Generate Rofi theme
  rofiTheme = fileFromTemplate "${themeName}-rofi.rasi" ''
    /* ${themeName} Rofi configuration */
    /* A cyberpunk interface for elite hackers */
    
    * {
      bg-color: ${colors.bg.base};
      bg-alt-color: ${colors.bg.surface};
      fg-color: ${colors.fg.primary};
      fg-alt-color: ${colors.fg.tertiary};
      
      selected-bg-color: ${colors.blue.deep};
      selected-fg-color: ${colors.fg.primary};
      
      border-color: ${colors.blue.mid};
      
      blue: ${colors.blue.brightest};
      purple: ${colors.purple.bright};
      cyan: ${colors.cyan.mid};
      
      font: "Berkeley Mono 12";
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
    
    mainbox {
      border: 0;
      padding: 0;
    }
    
    message {
      border: 0;
      padding: 1px;
    }
    
    textbox {
      text-color: @fg-color;
    }
    
    inputbar {
      children: [prompt, textbox-prompt-colon, entry, case-indicator];
      margin: 0 0 10px 0;
    }
    
    textbox-prompt-colon {
      expand: false;
      str: ":";
      text-color: @fg-alt-color;
    }
    
    entry {
      margin: 0 0 0 5px;
    }
    
    listview {
      border: 0;
      padding: 5px;
      columns: 1;
      lines: 8;
      fixed-height: true;
    }
    
    element {
      border: 0;
      padding: 5px;
      border-radius: 4px;
    }
    
    element normal.normal {
      background-color: @bg-color;
      text-color: @fg-color;
    }
    
    element normal.urgent {
      background-color: ${colors.red.mid};
      text-color: @fg-color;
    }
    
    element normal.active {
      background-color: ${colors.blue.darkest};
      text-color: @fg-color;
    }
    
    element selected.normal {
      background-color: @selected-bg-color;
      text-color: @selected-fg-color;
    }
    
    element selected.urgent {
      background-color: ${colors.red.deep};
      text-color: @selected-fg-color;
    }
    
    element selected.active {
      background-color: ${colors.blue.mid};
      text-color: @selected-fg-color;
    }
    
    element alternate.normal {
      background-color: @bg-color;
      text-color: @fg-color;
    }
    
    element alternate.urgent {
      background-color: ${colors.red.mid};
      text-color: @fg-color;
    }
    
    element alternate.active {
      background-color: ${colors.blue.darkest};
      text-color: @fg-color;
    }
    
    sidebar {
      border: 0;
    }
    
    button {
      text-color: @fg-alt-color;
      border-radius: 4px;
      padding: 5px;
    }
    
    button selected {
      background-color: @selected-bg-color;
      text-color: @selected-fg-color;
    }
    
    scrollbar {
      width: 4px;
      border: 0;
      handle-color: @fg-alt-color;
      handle-width: 8px;
      padding: 0;
    }
  '';
  
  # Create final derivation
  allThemes = pkgs.symlinkJoin {
    name = "${themeName}-themes";
    paths = [
      emacsTheme
      nvimTheme
      nvimLuaTheme
      tmuxTheme
      starshipConfig
      dircolorsConfig
      ghosttyConfig
      i3Config
      polybarConfig
      alacrittyConfig
      rofiTheme
    ];
  };
  
  # Create a derivation that installs all the themes
  installScript = pkgs.writeScriptBin "install-${themeName}-theme" ''
    #!/usr/bin/env bash
    
    THEME_NAME="${themeName}"
    DEST_DIR="$HOME/.config/$THEME_NAME"
    
    mkdir -p "$DEST_DIR"
    mkdir -p "$HOME/.config/nvim/colors"
    mkdir -p "$HOME/.emacs.d/themes"
    mkdir -p "$HOME/.config/alacritty"
    mkdir -p "$HOME/.config/rofi"
    mkdir -p "$HOME/.config/tmux"
    mkdir -p "$HOME/.config/starship"
    mkdir -p "$HOME/.config/i3"
    mkdir -p "$HOME/.config/polybar"
    mkdir -p "$HOME/.config/ghostty"
    
    # Copy theme files to their respective locations
    cp ${emacsTheme}/share/emacs/site-lisp/${themeName}-theme.el "$HOME/.emacs.d/themes/"
    cp ${nvimTheme}/share/vim/vimfiles/colors/${themeName}.vim "$HOME/.config/nvim/colors/"
    cp ${nvimLuaTheme}/share/vim/vimfiles/colors/${themeName}.lua "$HOME/.config/nvim/colors/"
    cp ${tmuxTheme}/share/tmux/${themeName}-tmux.conf "$HOME/.config/tmux/${themeName}.conf"
    cp ${starshipConfig}/share/starship/${themeName}-starship.toml "$HOME/.config/starship/${themeName}.toml"
    cp ${dircolorsConfig}/share/dircolors/${themeName}.dircolors "$DEST_DIR/dircolors"
    cp ${ghosttyConfig}/share/ghostty/${themeName}-ghostty.conf "$HOME/.config/ghostty/${themeName}.conf"
    cp ${i3Config}/share/i3/${themeName}-i3-colors "$HOME/.config/i3/${themeName}-colors"
    cp ${polybarConfig}/share/polybar/${themeName}-polybar-colors.ini "$HOME/.config/polybar/${themeName}-colors.ini"
    cp ${alacrittyConfig}/share/alacritty/${themeName}-alacritty.yml "$HOME/.config/alacritty/${themeName}.yml"
    cp ${rofiTheme}/share/rofi/${themeName}-rofi.rasi "$HOME/.config/rofi/${themeName}.rasi"
    
    # Create activation helpers
    cat > "$DEST_DIR/activate.sh" << EOF
    #!/usr/bin/env bash
    
    # Activate ${themeName} theme across applications
    
    # Starship
    cp "$HOME/.config/starship/${themeName}.toml" "$HOME/.config/starship.toml"
    
    # Dircolors
    echo 'eval "\$(dircolors -b $HOME/.config/${themeName}/dircolors)"' > "$HOME/.${themeName}-dircolors"
    
    # Check if the line is already in .bashrc or .zshrc
    grep -q "${themeName}-dircolors" "$HOME/.bashrc" || echo "source \$HOME/.${themeName}-dircolors" >> "$HOME/.bashrc"
    if [ -f "$HOME/.zshrc" ]; then
      grep -q "${themeName}-dircolors" "$HOME/.zshrc" || echo "source \$HOME/.${themeName}-dircolors" >> "$HOME/.zshrc"
    fi
    
    # Alacritty - append theme import to config
    if [ -f "$HOME/.config/alacritty/alacritty.yml" ]; then
      grep -q "import.*${themeName}.yml" "$HOME/.config/alacritty/alacritty.yml" || echo "import: [${themeName}.yml]" >> "$HOME/.config/alacritty/alacritty.yml"
    else
      echo "import: [${themeName}.yml]" > "$HOME/.config/alacritty/alacritty.yml"
    fi
    
    # Tmux
    if [ -f "$HOME/.tmux.conf" ]; then
      grep -q "source.*${themeName}.conf" "$HOME/.tmux.conf" || echo "source-file \$HOME/.config/tmux/${themeName}.conf" >> "$HOME/.tmux.conf"
    else
      echo "source-file \$HOME/.config/tmux/${themeName}.conf" > "$HOME/.tmux.conf"
    fi
    
    # i3 config
    if [ -f "$HOME/.config/i3/config" ]; then
      grep -q "include.*${themeName}-colors" "$HOME/.config/i3/config" || echo "include \$HOME/.config/i3/${themeName}-colors" >> "$HOME/.config/i3/config"
    fi
    
    # Polybar
    if [ -f "$HOME/.config/polybar/config.ini" ]; then
      grep -q "include-file.*${themeName}-colors.ini" "$HOME/.config/polybar/config.ini" || echo "include-file = \$HOME/.config/polybar/${themeName}-colors.ini" >> "$HOME/.config/polybar/config.ini"
    fi
    
    # Emacs - add to init.el
    if [ -f "$HOME/.emacs.d/init.el" ]; then
      grep -q "load-theme '${themeName}" "$HOME/.emacs.d/init.el" || echo "(load-theme '${themeName} t)" >> "$HOME/.emacs.d/init.el"
    fi
    
    # Neovim - add to init.vim or init.lua
    if [ -f "$HOME/.config/nvim/init.vim" ]; then
      grep -q "colorscheme ${themeName}" "$HOME/.config/nvim/init.vim" || echo "colorscheme ${themeName}" >> "$HOME/.config/nvim/init.vim"
    elif [ -f "$HOME/.config/nvim/init.lua" ]; then
      grep -q "colorscheme('${themeName}')" "$HOME/.config/nvim/init.lua" || echo "vim.cmd('colorscheme ${themeName}')" >> "$HOME/.config/nvim/init.lua"
    fi
    
    # Rofi
    if [ -f "$HOME/.config/rofi/config.rasi" ]; then
      sed -i "s/@theme \".*\"/@theme \"${themeName}\"/" "$HOME/.config/rofi/config.rasi"
    else
      echo '@theme "${themeName}"' > "$HOME/.config/rofi/config.rasi"
    fi
    
    # Ghostty
    if [ -f "$HOME/.config/ghostty/config" ]; then
      grep -q "include.*${themeName}.conf" "$HOME/.config/ghostty/config" || echo "include ~/.config/ghostty/${themeName}.conf" >> "$HOME/.config/ghostty/config"
    else
      echo "include ~/.config/ghostty/${themeName}.conf" > "$HOME/.config/ghostty/config"
    fi
    
    echo "${themeName} theme has been activated!"
    EOF
    
    chmod +x "$DEST_DIR/activate.sh"
    
    echo "${themeName} theme has been installed to $DEST_DIR"
    echo "To activate the theme across applications, run: $DEST_DIR/activate.sh"
  '';
in
pkgs.buildEnv {
  name = "${themeName}-theme-package";
  paths = [
    allThemes
    installScript
  ];
  
  meta = with lib; {
    description = "Ono-Sendai cyberpunk theme for various applications";
    longDescription = ''
      A comprehensive cyberpunk theme inspired by the Ono-Sendai aesthetic.
      Includes themes for Emacs, Neovim, Tmux, Alacritty, Rofi, i3, Polybar, and more.
    '';
    license = licenses.mit;
    platforms = platforms.all;
  };
}
