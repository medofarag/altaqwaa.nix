{
  description = "Altaqwa on Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        altaqwa = pkgs.appimageTools.wrapType2 rec {

          pname = "altaqwa";
          version = "4.0.1";

          src = pkgs.fetchurl {
            url = "https://github.com/rn0x/altaqwaa-desktop/releases/download/v${version}/Altaqwaa-${version}.AppImage";
            sha256 = "sha256:7ef66eeaa22d532fb2e55f04deb52dd43b511f1eff330b1a46c0c37cdc7d0fee";
          };

          extraInstallCommands =
            let
              contents = pkgs.appimageTools.extract { inherit pname version src; };
            in
            ''
              mkdir -p $out/share/applications/
              cp ${contents}/org.altaqwaa.Altaqwaa.desktop $out/share/applications/${pname}.desktop
              chmod 444 $out/share/applications/${pname}.desktop
              substituteInPlace $out/share/applications/${pname}.desktop \
                --replace 'Exec=AppRun' 'Exec=${pname}'
              cp -r ${contents}/usr/share/icons $out/share
            '';

        };
      in
      {
        packages = {
          inherit altaqwa;
          default = altaqwa;
        };
      }
    );
}
