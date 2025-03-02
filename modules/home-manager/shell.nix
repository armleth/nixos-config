{ pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';

      shellInit = ''
        fish_vi_key_bindings
      '';

      functions = {
        fish_user_key_bindings = ''
          for mode in insert default visual
              bind -M $mode \cf  forward-char
          end
        '';
      };

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/.";
        vi = "nvim";
        vim = "nvim";
        f = "cd $(fd --type d --hidden --exclude .java --exclude .cargo --exclude .rustup --exclude .emacs.d --exclude .pex --exclude .cabal --exclude .dotnet --exclude .vscode --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv --exclude .jupyter --exclude .ssh --exclude .gnupg --exclude .nix-defexpr --exclude .powerlevel10k --exclude .docker --exclude .pki --exclude .ipython --exclude .steam --exclude .local --exclude .opam | fzf --preview='ls --color {}')";

        # Git aliases
        gco = "git checkout";
        gst = "git status";
        ls = "eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first";
        tree = "eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first --tree";
      };

      plugins = [
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            "owner" = "Aloxaf";
            "repo" = "fzf-tab";
            "rev" = "6aced3f35def61c5edf9d790e945e8bb4fe7b305";
            "hash" = "sha256-EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=";
          };
        }
      ];
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
          {
            name = "romkatv/powerlevel10k";
            tags = [
              "as:theme"
              "depth:1"
            ];
          }
        ];
      };

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/.";
        vim = "nvim";
        f = "cd $(fd --type d --hidden --exclude .java --exclude .cargo --exclude .rustup --exclude .emacs.d --exclude .pex --exclude .cabal --exclude .dotnet --exclude .vscode --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv --exclude .jupyter --exclude .ssh --exclude .gnupg --exclude .nix-defexpr --exclude .powerlevel10k --exclude .docker --exclude .pki --exclude .ipython --exclude .steam --exclude .local --exclude .opam | fzf --preview='ls --color {}')";
      };
    };
  };
}
