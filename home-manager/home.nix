{ lib, config, pkgs, ... }:

{
    home = {
        username = "armleth";
        homeDirectory = "/home/armleth";
    };

    home.packages = with pkgs; [
        ripgrep
        fzf
        fd
    ];

    # Gnome settings
    dconf.enable = true;
    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
        };
        "org/gnome/shell" = {
            disable-user-extensions = false;

            enabled-extensions = [
                "space-bar@luchrioh"
                "transparent-top-bar@ftpix.com"
            ];
        };

        # Keybindings
        "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>Return";
            command = "gnome-terminal";
            name = "open-terminal";
        };
    };


    programs = {
        git = {
            enable = true;
            userName = "Armleth";
            userEmail = "armand.thibaudon@gmail.com";
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
