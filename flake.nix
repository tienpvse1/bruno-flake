{
  description = "Wrapped Bruno AppImage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      brunoAppImage = pkgs.fetchurl {
        url = "https://github.com/usebruno/bruno/releases/download/v3.4.1/bruno_3.4.1_x86_64_linux.AppImage";
        sha256 = "sha256-GApUVozQeoMHcwDwlWWoYgPfL9jx5RZTykej5pcJAWk=";
      };
    in
    {
      packages.${system}.default =
      let
        app = pkgs.writeShellScriptBin "bruno" ''
          exec ${pkgs.appimage-run}/bin/appimage-run ${brunoAppImage}
        '';

        brunoIcon = pkgs.fetchurl {
          url = "https://www.usebruno.com/favicon.ico";
          hash = "sha256-...";
        };

        desktop = pkgs.makeDesktopItem {
          name = "bruno";
          desktopName = "Bruno";
          exec = "bruno";
          terminal = false;
          categories = [ "Development" "Network" ];
        };
        icon = pkgs.runCommand "bruno-icon" {} ''
           mkdir -p $out/share/icons/hicolor/256x256/apps
           cp ${brunoIcon} \
           $out/share/icons/hicolor/256x256/apps/bruno.ico
        '';
      in
      pkgs.symlinkJoin {
        name = "bruno-appimage";

        paths = [
          app
          desktop
          icon
        ];
      };
    };
}
