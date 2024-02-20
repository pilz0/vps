{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-stable";
  };
  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      serva = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };

}
