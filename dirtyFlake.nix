
{
  description = "A way to transport niv inputs to flake inputs";
  inputs = let
    inherit (builtins) readFile attrNames fromJSON listToAttrs;
    packageSources = fromJSON (readFile ./nix/sources.json);
    mapAttrs = f: attrs: listToAttrs (map (k: { name = k; value = f k (attrs.${k}); }) (attrNames attrs));
  in mapAttrs (k: v: {
    inherit (v) url;
    flake = v.flake or false;
  }) packageSources;
  outputs = { self, nixpkgs, flake-utils, nixos-config, ... }:
    let
      inherit (flake-utils.lib) eachDefaultSystem flattenTree;
    in
    {
      lib = {
        augmentCallPackage = callPackage: defaultArgs: f: extraArgs: let
          fn = if builtins.isFunction f then f else import f;
          args = builtins.intersectAttrs defaultArgs (builtins.functionArgs fn);
        in
        callPackage fn (args // extraArgs);
        mkSystem = modules: nixpkgs.lib.nixosSystem {
            inherit modules;
            extraArgs.system = "x86_64-linux";
            system = "x86_64-linux";
        };
      };
      defaultTemplate = {
        path = ./.;
        description = "nix flakes for niv users";
      };
    } // eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      monorepo = import nixos-config { inherit pkgs; };
    in
    {
      packages = flattenTree {
        inherit (monorepo) nix;
        python = monorepo.callNixPackage ({ python3 }: python3) {};
      };
    });

}
