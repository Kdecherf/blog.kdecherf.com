let
  # From https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=hugo
  # git rev-list -n 20 nixpkgs-unstable -- pkgs/by-name/hu/hugo/package.nix | xargs -I{} git grep -E '^\s+version\s?=\s?"[^"]+"\s*;\s*$' {} -- pkgs/by-name/hu/hugo/package.nix
  pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/9549f5d9d56a1a21d7f3f4bc80e6af5a98392c69.tar.gz";
      }) {};
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    hugo
  ];
}
