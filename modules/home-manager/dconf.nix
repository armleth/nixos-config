{ lib, root, ... }:

{
  dconf = {
    enable = true;
    settings =
      let
        workspaces = [
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
          "0"
        ];
      in
      {
        # General settings
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          clock-show-weekday = true;
          show-battery-percentage = true;
          enable-animations = true;
          enable-hot-corners = false;

          # Prevent having white square as cursor when switching wm
          cursor-theme = "Adwaita";
        };

        "org/gnome/mutter" = {
          workspaces-only-on-primary = true;
          dynamic-workspaces = false;
        };

        "org/gnome/desktop/background" =
          let
            big_sur = (root + /statics/wallpapers/Big_Sur-timed.xml);
            nix_dark = (root + /statics/wallpapers/nix-wallpaper-simple-dark-gray.png);
          in
          {
            picture-uri = "file://${nix_dark}";
            picture-uri-dark = "file://${nix_dark}";

            # Nixos base version
            # primary-color = "#023c88";
            # secondary-color = "#5789ca";
          };

        # Extensions
        "org/gnome/shell" = {
          disable-user-extensions = false;
          disable-extension-version-validation = true;

          enabled-extensions = [
            "space-bar@luchrioh"
            "Resource_Monitor@Ory0n"
            "transparent-top-bar@ftpix.com"
            "no-titlebar-when-maximized@alec.ninja"
            "PrivacyMenu@stuarthayhurst"
            "Bluetooth-Battery-Meter@maniacx.github.com"
            "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
          ];
        };

        "org/gnome/shell/extensions/space-bar" = {
          "appearance/workspace-margin" = 1;
          "behavior/show-empty-workspaces" = false;
          "behavior/toggle-overview" = false;
          "shortcuts/open-menu" = [ "<Shift><Control>m" ];
        };

        "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
          enable-battery-level-text = true;
          enable-battery-indicator-text = true;
        };

        "com/github/Ory0n/Resource_Monitor" = {
          diskspacestatus = false;
          diskstatsstatus = false;
          netethstatus = false;
          netwlanstatus = false;
          ramunit = "perc";
          refreshtime = 1;
        };

        "com/ftpix/transparentbar" = {
          transparency = 0;
        };

        # General keybindings
        "org/gnome/desktop/wm/keybindings" =
          {
            close = [ "<Shift><Super>q" ];
            maximize = [
              "<Super>Up"
              "<Super>w"
            ];
            switch-applications = [ ];
            switch-applications-backward = [ ];
            switch-windows = [ "<Alt>Tab" ];
            switch-windows-backward = [ "<Shift><Alt>Tab" ];
          }
          // (builtins.listToAttrs (
            (builtins.map (
              workspace_number:
              lib.attrsets.nameValuePair "switch-to-workspace-${workspace_number}" [
                "<Super>${workspace_number}"
              ]
            ) workspaces)
            ++ (builtins.map (
              workspace_number:
              lib.attrsets.nameValuePair "move-to-workspace-${workspace_number}" [
                "<Shift><Super>${workspace_number}"
              ]
            ) workspaces)
          ));

        "org/gnome/shell/keybindings" =
          {
            toggle-overview = [ "<Super>d" ];
            show-screenshot-ui = [ "<Shift><Super>s" ];
          }
          // (builtins.listToAttrs (
            # Remove default keybindings for <Super>[12345678910]
            builtins.map (
              workspace_number: lib.attrsets.nameValuePair "switch-to-application-${workspace_number}" [ ]
            ) workspaces
          ));

        # Custom keybindings
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>Return";
          command = "alacritty";
          name = "open-terminal";
        };

        # Workspaces settings
        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 10;
          workspaces-names = workspaces;
          auto-raise = false;
          focus-mode = "sloppy";
        };

        "org/gnome/shell/window-switcher" = {
          current-workspace-only = false;
        };

        # Keyboard settings
        # "org/gnome/desktop/input-sources" = {
        #   xkb-options = [ "caps:escape,altwin:swap_lalt_lwin" ];
        # };
      };
  };
}
