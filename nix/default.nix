let
  sources = import ./sources.nix;
  # i know, irresponsible AF 
  flake-compat = sources.flake-compat or (builtins.fetchGit {
    url = "https://github.com/edolstra/flake-compat";
    rev = "99f1c2157fba4bfe6211a321fd0ee43199025dbf";
  });
  inputs = builtins.mapAttrs (k: v: if v.flake or false then (import flake-compat { src = v; }).defaultNix else v ) sources;
  flake = import ../flake.nix;
  # don't assume that we already have this function from nixpkgs
  fix = f: let x = f x; in x;
in
  fix (self: flake.outputs ({ inherit self; } // inputs))


