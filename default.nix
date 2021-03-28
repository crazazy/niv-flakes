if builtins ? getFlake then (builtins.getFlake "path:./.").outputs else import ./nix
