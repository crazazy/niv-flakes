{
description = "A way to transport niv inputs to flake inputs";
inputs = {
  flake-utils = {
    flake = true;
    url = "https://github.com/numtide/flake-utils/archive/997f7efcb746a9c140ce1f13c72263189225f482.tar.gz";
  };
  niv = {
    flake = false;
    url = "https://github.com/nmattia/niv/archive/e0ca65c81a2d7a4d82a189f1e23a48d59ad42070.tar.gz";
  };
  nixos-config = {
    flake = false;
    url = "https://github.com/crazazy/nixos-config/archive/8e318c8773d0f8bed690a96ff9b74ce5f9d64d07.tar.gz";
  };
  nixpkgs = {
    flake = true;
    url = "https://github.com/NixOS/nixpkgs/archive/eb73405ecceb1dc505b7cbbd234f8f94165e2696.tar.gz";
  };
};
outputs = args: (import ./dirtyFlake.nix).outputs args;
}
