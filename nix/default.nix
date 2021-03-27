let
  sources = import ./sources.nix;
  inherit (sources) nixpkgs nixos-config;
in
  import nixos-config { pkgs = nixpkgs; }
