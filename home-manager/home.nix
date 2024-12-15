{ lib, config, pkgs, pkgsUnstable, root, ... }:

{
    home = {
        username = "armleth";
        homeDirectory = "/home/armleth";
    };

    home.packages = [
        pkgs.ripgrep
        pkgs.fzf
        pkgs.fd

        # gnome extensions from stable branch
        pkgs.gnomeExtensions.space-bar
        pkgs.gnomeExtensions.transparent-top-bar-adjustable-transparency
        pkgs.gnomeExtensions.no-titlebar-when-maximized
        pkgs.gnomeExtensions.privacy-settings-menu

        # gnome extensions from unstable branch - generally because of gnome version conflicts
        pkgsUnstable.gnomeExtensions.resource-monitor
    ];

    # Gnome settings
    dconf.enable = true;
    dconf.settings =
    let 
        workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0"];
    in
    {
        # General settings
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            clock-show-weekday = true;
            show-battery-percentage = true;
            enable-animations = true;
            enable-hot-corners = false;

            # prevent having white square as cursor when switching wm
            cursor-theme = "Adwaita";
        };

        "org/gnome/desktop/background" = 
        let
            big_sur = (root + /statics/wallpapers/Big_Sur-timed.xml);
            nix_dark = (root + /statics/wallpapers/nix-wallpaper-simple-dark-gray.png);
        in {
            picture-uri = "file://${nix_dark}";
            picture-uri-dark = "file://${nix_dark}";

            # nixos base version
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
            ];
        };

        "org/gnome/shell/extensions/space-bar" = {
            "appearance/workspace-margin" = 1;
            "behavior/show-empty-workspaces" = false;
            "behavior/toggle-overview" = false;
            "shortcuts/open-menu" = ["<Shift><Control>m"];
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
        "org/gnome/desktop/wm/keybindings" = {
            close = ["<Shift><Super>q"];
            maximize = ["<Super>Up" "<Super>w"];
        } // (
            builtins.listToAttrs (
                (
                    builtins.map
                    (workspace_number: lib.attrsets.nameValuePair
                        "switch-to-workspace-${workspace_number}"
                        ["<Super>${workspace_number}"]
                    )
                    workspaces
                ) ++ (
                    builtins.map
                    (workspace_number: lib.attrsets.nameValuePair
                        "move-to-workspace-${workspace_number}"
                        ["<Shift><Super>${workspace_number}"]
                    )
                    workspaces
                )
            )
        );

        "org/gnome/shell/keybindings" = {
            toggle-overview = ["<Super>d"];
            show-screenshot-ui = ["<Shift><Super>s"];
        } // (
            builtins.listToAttrs (
                # remove default keybindings for <Super>[12345678910]
                builtins.map
                (workspace_number: lib.attrsets.nameValuePair
                     "switch-to-application-${workspace_number}"
                     []
                )
                workspaces
            )
        );

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
        "org/gnome/desktop/input-sources" = {
            xkb-options = ["caps:escape,altwin:swap_lalt_lwin"];
        };
    };


    programs = {
        git = {
            enable = true;
            userName = "Armleth";
            userEmail = "armleth@proton.me";
        };

        firefox = {
            enable = true;

            policies = {
                ExtensionSettings = {
                    # blocks all addons except the ones specified below
                    "*".installation_mode = "blocked"; 

                    # ublock origin
                    "uBlock0@raymondhill.net" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                        installation_mode = "force_installed";
                    };

                    # GNOME Shell integration
                    "chrome-gnome-shell@gnome.org" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/gnome-shell-integration/latest.xpi";
                        installation_mode = "force_installed";
                    };

                    # infinity pegasus
                    "{9a066f3e-5093-471f-9495-fd8618959c81}" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/infinity-pegasus/latest.xpi";
                        installation_mode = "force_installed";
                    };

                    # languages packs
                    "langpack-en-US@firefox.mozilla.org" = {
                        installation_mode = "normal_installed";
                        install_url = "https://releases.mozilla.org/pub/firefox/releases/${config.programs.firefox.package.version}/linux-x86_64/xpi/en-US.xpi";
                    };
                    "langpack-fr@firefox.mozilla.org" = {
                        installation_mode = "normal_installed";
                        install_url = "https://releases.mozilla.org/pub/firefox/releases/${config.programs.firefox.package.version}/linux-x86_64/xpi/fr.xpi";
                    };
                };

                Preferences =
                let
                    lock-false = {
                        Value = false;
                        Status = "locked";
                    };
                    lock-true = {
                        Value = true;
                        Status = "locked";
                    };
                in {
                    "extensions.pocket.enabled" = lock-false;
                    "extensions.screenshots.disabled" = lock-true;
                    "browser.newtabpage.activity-stream.showSponsored" = lock-false;
                    "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
                    "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
                };
            };
        };

        alacritty = {
            enable = true;
            settings = {
                shell.program = "${pkgs.zsh}/bin/zsh";
                font = {
                    size = 14;

                    normal.family = "MesloLGS NF";
                    bold.family = "MesloLGS NF";
                    italic.family = "MesloLGS NF";
                };
            };
        };

        zsh = {
            enable = true;
            initExtra = ''
                [[ ! -f ${./p10k-config/p10k.zsh} ]] || source ${./p10k-config/p10k.zsh}

                bindkey -e
                bindkey '^[[1;5C' forward-word
                bindkey '^[[1;5D' backward-word
            '';

            zplug = {
                enable = true;
                plugins = [
                { name = "zsh-users/zsh-syntax-highlighting"; }
                { name = "zsh-users/zsh-completions"; }
                { name = "zsh-users/zsh-autosuggestions"; }
                { name = "Aloxaf/fzf-tab"; }
                { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
                ];
            };

            shellAliases = {
                rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/.";
                vim = "nvim";
                # f = 'cd $(fd --type d --hidden \
                #         --exclude .java \
                #         --exclude .cargo \
                #         --exclude .rustup \
                #         --exclude .emacs.d \
                #         --exclude .pex \
                #         --exclude .cabal \
                #         --exclude .dotnet \
                #         --exclude .vscode \
                #         --exclude .git \
                #         --exclude node_module \
                #         --exclude .cache \
                #         --exclude .npm \
                #         --exclude .mozilla \
                #         --exclude .meteor \
                #         --exclude .nv \
                #         --exclude .jupyter \
                #         --exclude .ssh \
                #         --exclude .gnupg \
                #         --exclude .nix-defexpr \
                #         --exclude .powerlevel10k \
                #         --exclude .docker \
                #         --exclude .pki \
                #         --exclude .ipython \
                #         --exclude .steam \
                #         --exclude .local \
                #         --exclude .opam \
                #         | fzf --preview="ls --color {}")';
            };
        };
    };

    home.stateVersion = "24.05";

    programs.home-manager.enable = true;
}
