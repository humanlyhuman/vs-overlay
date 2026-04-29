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

            overlays = [
              (final: prev: {
                cudaPackages = prev.cudaPackages_12_6;
              })

              self.overlays.default
            ];

            config.allowUnfree = true;
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
        _: pkgsForSystem:
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
              inherit (pkgsForSystem) getnative nativeres vsview;
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

          toolPkgs =
            lib.filterAttrs
            (
              _: pkg:
                lib.isDerivation pkg
                && !(pkg.meta.broken or false)
                && lib.meta.availableOn platform pkg
            )
            {
              inherit
                (pkgsForSystem)
                getnative
                nativeres
                vsview
                ;
            };

          tools =
            toolPkgs
            // {
              all =
                pkgsForSystem.linkFarm "all-tools"
                (
                  lib.mapAttrsToList
                  (name: drv: {
                    inherit name;
                    path = drv;
                  })
                  toolPkgs
                );
            };
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

    all-tools = tools.all;
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
