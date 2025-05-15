{
  description = "Flake to manage my NixOS system.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, home-manager, ...}:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
        nixosConfigurations = {
          nixos-vm1 = lib.nixosSystem {
            inherit system;
            modules = [ ./system/configuration-nixos-vm1-specific.nix ];
      };
    };

    homeConfigurations = {
      amaury = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./user/home.nix ];
      };
    };
  };
  
}
