{
  description = "Flake for avante.nvim plugin";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    avante = {
      url = "github:yetone/avante.nvim/v0.0.8";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { selt, nixpkgs, flake-utils, avante, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      packages = stdenv.mkDerivation rec {
        name = "avante.nvim";

        src = avante;

        buildInputs = [ pkgs.cargo ];

        buildPhase = ''
          echo "Copying python scripts to derivation"
          make
        '';

        #installPhase = ''
        #  mkdir -p $out/scripts

        #  cp usr/share/handygccs/scripts/constants.py $out/scripts
        #  cp usr/share/handygccs/scripts/handycon.py $out/scripts
        #'';
      };
      # nix build
      #defaultPackage = pkgs.hello;

      # nix develop .#hello or nix shell .#hello
      #devShells.hello = pkgs.mkShell { buildInputs = [ pkgs.hello pkgs.cowsay ]; };
      
      # nix develop or nix shell
      #devShell = pkgs.hello;        
    }
  );
}
