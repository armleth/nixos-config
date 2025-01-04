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
        pkgs.slack
        pkgs.vscode
        pkgs.chromium
        pkgs.tmux
        pkgs.gnumake
        pkgs.gcc
        pkgs.criterion
        pkgs.clang-tools

        # gnome extensions from stable branch
        pkgs.gnomeExtensions.space-bar
        pkgs.gnomeExtensions.transparent-top-bar-adjustable-transparency
        pkgs.gnomeExtensions.no-titlebar-when-maximized
        pkgs.gnomeExtensions.privacy-settings-menu

        # gnome extensions from unstable branch - generally because of gnome version conflicts
        pkgsUnstable.gnomeExtensions.resource-monitor
    ];

    imports = [
        ./dconf.nix
    ];

    programs = {
        git = {
            enable = true;
            userName = "Armleth";
            userEmail = "armand.thibaudon@epita.fr";
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
                        default_area = "navbar";
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

                    # bitwarden
                    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                        installation_mode = "force_installed";
                        default_area = "navbar";
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
                # shell.program = "${pkgs.zsh}/bin/zsh";
                shell.program = "${pkgs.fish}/bin/fish";
                font = {
                    size = 14;

                    normal.family = "MesloLGS NF";
                    bold.family = "MesloLGS NF";
                    italic.family = "MesloLGS NF";
                };
            };
        };

        fish = {
            enable = true;
            interactiveShellInit = ''
                set fish_greeting # Disable greeting
                '';
            shellAliases = {
                rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/.";
                vim = "nvim";
                # f = "cd $(fd --type d --hidden \
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
                #         | fzf --preview='ls --color {}')";
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
                f = "cd $(fd --type d --hidden \
                        --exclude .java \
                        --exclude .cargo \
                        --exclude .rustup \
                        --exclude .emacs.d \
                        --exclude .pex \
                        --exclude .cabal \
                        --exclude .dotnet \
                        --exclude .vscode \
                        --exclude .git \
                        --exclude node_module \
                        --exclude .cache \
                        --exclude .npm \
                        --exclude .mozilla \
                        --exclude .meteor \
                        --exclude .nv \
                        --exclude .jupyter \
                        --exclude .ssh \
                        --exclude .gnupg \
                        --exclude .nix-defexpr \
                        --exclude .powerlevel10k \
                        --exclude .docker \
                        --exclude .pki \
                        --exclude .ipython \
                        --exclude .steam \
                        --exclude .local \
                        --exclude .opam \
                        | fzf --preview='ls --color {}')";
            };
        };
    };

    home.stateVersion = "24.05";

    programs.home-manager.enable = true;
}
