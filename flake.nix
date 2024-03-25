{
  description = "Customized dmenu";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      overlay = final: prev: {
        dmenu = prev.dmenu.overrideAttrs (old: {
          version = "5.3";
          src = builtins.path { path = ./.; name = "dmenu"; };
        });
      };

      dmenu = (
        import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        }
      ).dmenu;
    in
    {
      overlays.default = overlay;

      packages.${system}.default = dmenu;

      checks.${system} = {
        build = dmenu;

        version = nixpkgs.legacyPackages.${system}.runCommand "version-check" { } ''
          dmenu_version="$(${dmenu}/bin/dmenu -v)"

          echo "package version: ${dmenu.name}"
          echo "dmenu version:   $dmenu_version"

          [[ "${dmenu.name}" == "$dmenu_version" ]]
          touch ${placeholder "out"}
        '';
      };
    };
}
