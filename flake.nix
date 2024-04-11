{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    defaultPackage.x86_64-linux;
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
