
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
      mapAttrs = f: attrs: builtins.listToAttrs (map (k: { name = k; value = f k attrs.${k}; }) (builtins.attrNames attrs));
      mkSystem = modules: nixpkgs.lib.nixosSystem {
        inherit modules;
        extraArgs.system = "x86_64-linux";
        system = "x86_64-linux";
      };
    in
    eachDefaultSystem (system: let
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
