{
  description = "vs-overlay";

  nixConfig = {
    extra-substituters = [
      "https://humanlyhuman-vs-repo.cachix.org"
    ];

    extra-trusted-public-keys = [
      "humanlyhuman-vs-repo.cachix.org-1:3Dep7SJrZH4ao/jMu9KF4vd8Ul0AHlSj6GNMISDP96I="
    ];
  };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  } @ inputs: let
    inherit (nixpkgs) lib;

    buildPlatforms = import ./lib/platforms.nix inputs;

    eachSystem = f: lib.mapAttrs f buildPlatforms;

    pkgs = eachSystem (
      system: _:
        import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];

          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        }
    );
  in {
    overlays.default = import ./default.nix;

    formatter = eachSystem (
      system: _: pkgs.${system}.nixfmt-tree
    );

    packages = eachSystem (
      system: platform:
        lib.filterAttrs (_: pkg: lib.meta.availableOn platform pkg) (
          {
            inherit (pkgs.${system}) getnative;
            inherit (pkgs.${system}) nativeres;
          }
          // lib.filterAttrs (_: lib.isDerivation)
          pkgs.${system}.vapoursynthPlugins
        )
    );

    hydraJobs = let
      flatten = system: attrs:
        lib.concatMapAttrs
        (
          name: value:
            if lib.isDerivation value
            then {"${system}-${name}" = value;}
            else if lib.isAttrs value
            then flatten system value
            else {}
        )
        attrs;
    in
      lib.concatMapAttrs flatten self.packages;

    devShells = eachSystem (
      system: _: {
        everything = pkgs.${system}.mkShell {
          packages = [
            (pkgs.${system}.vapoursynth.withPlugins (
              builtins.filter
              (pkg: lib.isDerivation pkg && lib.meta.availableOn system pkg)
              (builtins.attrValues pkgs.${system}.vapoursynthPlugins)
            ))
          ];
        };
      }
    );
  };
}
