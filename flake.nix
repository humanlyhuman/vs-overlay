{
  description = "vs-overlay";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }@inputs:
    let
      inherit (nixpkgs) lib;
      buildPlatforms = import ./lib/platforms.nix inputs;
      eachSystem = uwu: lib.mapAttrs uwu buildPlatforms;
      nixpkgsFor = eachSystem (system: _:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        }
      );

    in
    {
      overlays.default = import ./default.nix;
      packages = eachSystem (system: platform:
        lib.filterAttrs (_: pkg: lib.meta.availableOn platform pkg) ({
          inherit (nixpkgsFor.${system}) getnative;
        } // lib.filterAttrs (_: lib.isDerivation) nixpkgsFor.${system}.vapoursynthPlugins)
      );

      hydraJobs = { inherit (self) packages; };
    };
}
