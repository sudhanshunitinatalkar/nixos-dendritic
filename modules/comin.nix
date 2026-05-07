{ lib, inputs, ... }:
let
  cominModule = { pkgs, ... }: {
    # Import the comin NixOS module from your flake inputs
    imports = [ inputs.comin.nixosModules.comin ];

    services.comin = {
      enable = true;
      remotes = [
        {
          url = "https://github.com/sudhanshunitinatalkar/nixos-dendritic.git";
          branches.main.name = "main";
        }
      ];
    };

    # Git must be installed for comin to pull from GitHub
    environment.systemPackages = [ pkgs.git ];
  };

  # Only putting the server here!
  targetHosts = [ "cosmosserver" ]; 
in
{
  configurations.nixos = lib.genAttrs targetHosts (name: {
    module = cominModule;
  });
}