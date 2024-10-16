{
    description = "Armleth's NixOS flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
        nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        nixpkgs,
        nixpkgsUnstable,
        home-manager,
        ...
    }:
    let
        system = "x86_64-linux";
    in {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
                inherit system;
                
                modules = [
                    ./configuration.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.armleth = import ./home-manager/home.nix;

                        home-manager.extraSpecialArgs = {
                            pkgsUnstable = import nixpkgsUnstable {
                                inherit system;
                                config.allowUnfree = true;
                            };
                        };
                    }
                ];
        };
    };
}
