let
  # From https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=hugo
  pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/e6f23dc08d3624daab7094b701aa3954923c6bbb.tar.gz";
      }) {};
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    hugo
  ];
}
