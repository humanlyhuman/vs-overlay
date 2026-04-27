# A Nix shell with VapourSynth and all plugins (from this overlay). Used for
# testing that all plugins in this overlay build.
{ vs-overlay }:
let
  pkgs = import <nixpkgs> {
    config.allowUnfree = true;
    overlays = [ (import vs-overlay) ];
    # Force default Python to 3.x
    config.packageOverrides = pkgs: {
      python = pkgs.python3;
    };
  };
in
# This should include all plugins exposed by this overlay.
pkgs.mkShell {
  packages = [
    (pkgs.vapoursynth.withPlugins (
      with pkgs.vapoursynthPlugins;
      builtins.attrValues pkgs.vapoursynthPlugins
    ))
  ];
}
