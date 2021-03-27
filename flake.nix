{
description = "A way to transport niv inputs to flake inputs";
inputs = {
  flake-utils = {
    flake = true;
    url = "https://github.com/numtide/flake-utils/archive/5466c5bbece17adaab2d82fae80b46e807611bf3.tar.gz";
  };
  niv = {
    flake = false;
    url = "https://github.com/nmattia/niv/archive/af958e8057f345ee1aca714c1247ef3ba1c15f5e.tar.gz";
  };
  nixos-config = {
    flake = false;
    url = "https://github.com/crazazy/nixos-config/archive/14060609e31f26969eae856d2693f17affa246f4.tar.gz";
  };
  nixpkgs = {
    flake = true;
    url = "https://github.com/NixOS/nixpkgs/archive/1eea37190739485a01f5036558cd2ff257985678.tar.gz";
  };
};
outputs = args: (import ./dirtyFlake.nix).outputs args;
}
