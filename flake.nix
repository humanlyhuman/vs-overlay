{
  description = "vs-overlay";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        }
      );
    in
    {
      overlay = import ./default.nix;
      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system})
          getnative;
      } // lib.filterAttrs (_: lib.isDerivation) nixpkgsFor.${system}.vapoursynthPlugins);

      hydraJobs = forAllSystems (system:
        lib.filterAttrs (_:
          lib.isDerivation
        ) nixpkgsFor.${system}.vapoursynthPlugins
      );
    };
}
