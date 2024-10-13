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

  outputs = { nixpkgs, flake-utils, avante, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      lockFile = avante + /Cargo.lock;
    in {
      packages.default = pkgs.rustPlatform.buildRustPackage {
        pname = "avante.nvim";
        version = "v0.0.8";
        src = avante;
        buildFeatures = [ "lua51" ];
      
        cargoLock = {
          inherit lockFile;
          outputHashes = {
            "mlua-0.10.0-beta.1" = "sha256-ZEZFATVldwj0pmlmi0s5VT0eABA15qKhgjmganrhGBY=";
          };
        };

        postInstall = ''
          cp -r . $out

          mkdir -p $out/build
          cp -r $out/lib/libavante_repo_map.so $out/build/avante_repo_map.so
          cp -r $out/lib/libavante_templates.so $out/build/avante_templates.so
          cp -r $out/lib/libavante_tokenizers.so $out/build/avante_tokenizers.so
        '';
      
        nativeBuildInputs = [ pkgs.pkg-config ];
        PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      };
    }
  );
}
