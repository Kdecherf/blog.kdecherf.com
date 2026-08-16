let
  # From https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=hugo
  # git rev-list -n 20 nixpkgs-unstable -- pkgs/by-name/hu/hugo/package.nix | xargs -I{} git grep -E '^\s+version\s?=\s?"[^"]+"\s*;\s*$' {} -- pkgs/by-name/hu/hugo/package.nix
  pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/023f5cbc13e335a868e07c1ce691961fca06e306.tar.gz";
      }) {};
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    hugo
  ];
}
