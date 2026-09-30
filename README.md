# altaqwaa.nix
flake.nix file to easy install altaqwaa app on nixos

## on flake.nix file
```
nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # replace 26.05 with any version you want
    altaqwaa = {
      url = "github:medofarag/altaqwaa.nix";
      inputs.nixpkgs.follows = "nixpkgs"; # optional
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { 
        inherit inputs;
      };
      modules = [
        ./configuration.nix                         # Your main configuration
      ];
    };
  };
}
```


## on configuration.nix file
```nix
{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.altaqwaa.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```


