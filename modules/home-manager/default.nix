{
  lib,
  config,
  pkgs,
  pkgsUnstable,
  root,
  ...
}:

{
  imports = [
    ./dconf.nix
    ./firefox.nix
    ./shell.nix
    ./tmux.nix
  ];

  home = {
    username = "armleth";
    homeDirectory = "/home/armleth";

    packages =
      (
        with pkgs;
        [
          # Basic unix tools
          bat
          eza
          fd
          fzf
          neofetch
          ripgrep

          # Apps
          calibre
          chromium
          slack
          vlc

          # Editor
          dwt1-shell-color-scripts
          neovim
          tmux
          vscode

          # Dev packages
          clang-tools
          cmake
          criterion
          gcc
          gnumake
          jdk17_headless
          lua-language-server
          nixd
          nixfmt-rfc-style
          nodejs
          pyright
          python312Full
          texliveFull
          typescript-language-server
          yaml-cpp
          vscode-langservers-extracted
          kubectl
          sqlfluff
        ]
        ++ (with jetbrains; [
          pycharm-professional
          idea-ultimate
          datagrip
        ])
        ++ (with gnomeExtensions; [
          bluetooth-battery-meter
          launch-new-instance
          no-titlebar-when-maximized
          privacy-settings-menu
          space-bar
          transparent-top-bar-adjustable-transparency
        ])
      )
      ++ (with pkgsUnstable; [
        # Gnome extensions from unstable branch - generally because of gnome version conflicts
        gnomeExtensions.resource-monitor
      ]);
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "application/pdf" = "org.gnome.Evince.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
    };
  };

  programs = {
    java = {
      package = pkgs.jdk17_headless;
      enable = true;
    };

    git = {
      enable = true;
      userName = "Armleth";
      userEmail = "armand.thibaudon@epita.fr";
    };

    alacritty = {
      enable = true;
      settings = {
        terminal.shell.program = "${pkgs.fish}/bin/fish";
        font = {
          size = 14;

          normal.family = "MesloLGS NF";
          bold.family = "MesloLGS NF";
          italic.family = "MesloLGS NF";
        };
      };
    };
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
