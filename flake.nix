{
  description = "art.jacobson.me — personal site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = {
        config,
        pkgs,
        lib,
        ...
      }: {
        packages = {
          default = config.packages.site;

          site = pkgs.stdenvNoCC.mkDerivation {
            pname = "art-jacobson-me";
            version = "0.1.0";

            # Only what Zola reads; edits to the README, CI workflow, or
            # flake itself don't invalidate the build.
            src = lib.fileset.toSource {
              root = ./.;
              fileset = lib.fileset.unions [
                ./config.toml
                ./content
                ./sass
                ./static
                ./templates
              ];
            };

            nativeBuildInputs = [pkgs.zola];

            dontBuild = true;

            installPhase = ''
              runHook preInstall
              zola build --output-dir "$out"
              runHook postInstall
            '';
          };
        };

        checks.site = config.packages.site;

        devShells.default = pkgs.mkShellNoCC {
          packages = [pkgs.zola pkgs.alejandra];

          shellHook = ''
            echo "art.jacobson.me — 'zola serve' to preview, 'nix build' to produce the artifact"
          '';
        };

        formatter = pkgs.alejandra;
      };
    };
}
