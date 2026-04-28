{
  description = "vs-overlay";

  nixConfig = {
    extra-substituters = [
      "https://humanlyhuman-vs-repo.cachix.org"
    ];

    extra-trusted-public-keys = [
      "humanlyhuman-vs-repo.cachix.org-1:zfX0GM54Ue2QJkBzzdx2uc8AyZ7xbVReKLchjhszxyc="
    ];
  };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
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

    flattenDerivations = attrs:
      lib.foldlAttrs
      (
        acc: name: value:
          acc
          // (
            if lib.isDerivation value
            then {${name} = value;}
            else if lib.isAttrs value
            then flattenDerivations value
            else {}
          )
      )
      {}
      attrs;

    allPackages = eachSystem (
      system: pkgsForSystem:
        flattenDerivations pkgsForSystem
    );
  in {
    overlays.default = import ./default.nix;

    formatter = eachSystem (
      system: _:
        pkgs.${system}.nixfmt-tree
    );

    packages = eachSystem (
      system: platform: let
        pkgsForSystem = pkgs.${system};

        base =
          {
            inherit (pkgsForSystem) getnative nativeres;
          }
          // lib.filterAttrs
          (
            _: pkg:
              lib.isDerivation pkg
              && !(pkg.meta.broken or false)
              && lib.meta.availableOn platform pkg
          )
          pkgsForSystem.vapoursynthPlugins;

        flat = flattenDerivations base;
      in
        base
        // {
          all =
            pkgsForSystem.linkFarm "all-packages"
            (
              lib.mapAttrsToList
              (name: drv: {
                inherit name;
                path = drv;
              })
              flat
            );
        }
    );

    checks = allPackages;

    hydraJobs =
      lib.foldlAttrs
      (
        acc: system: pkgsForSystem:
          acc
          // lib.mapAttrs'
          (name: drv: {
            name = "${system}-${name}";
            value = drv;
          })
          pkgsForSystem
      )
      {}
      allPackages;

    devShells = eachSystem (
      system: _: let
        pkgsForSystem = pkgs.${system};
      in {
        everything = pkgsForSystem.mkShell {
          packages = [
            (pkgsForSystem.vapoursynth.withPlugins (
              builtins.filter
              (
                pkg:
                  lib.isDerivation pkg
                  && lib.meta.availableOn system pkg
              )
              (builtins.attrValues pkgsForSystem.vapoursynthPlugins)
            ))
          ];
        };
      }
    );

    defaultPackage = eachSystem (
      system: _:
        self.packages.${system}.all
    );
  };
}
