{ lib, ... }:
let
  # 1. Define the module once
  tsModule = { ... }: {
    services.tailscale.enable = true;
  };

  # 2. Define a list of hosts that should get this module
  targetHosts = [ "cosmoslaptop" ];
in
{
  # 3. Automatically apply the module to every host in the list!
  configurations.nixos = lib.genAttrs targetHosts (name: {
    module = tsModule;
  });
}