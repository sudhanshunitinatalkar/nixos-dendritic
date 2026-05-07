{ lib, inputs, ... }:
let
  cominModule = { pkgs, ... }: {
    # Import the comin NixOS module from your flake inputs
    imports = [ inputs.comin.nixosModules.comin ];

    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/sudhanshunitinatalkar/nixos-dendritic.git";
          # Corrected branches syntax here:
          branches.main.name = "main"; 
        }
      ];
    };

    # Git must be installed for comin to pull from GitHub
    environment.systemPackages = [ pkgs.git ];
  };

  # Only targeting the server
  targetHosts = [ "cosmosserver" ]; 
in
{
  configurations.nixos = lib.genAttrs targetHosts (name: {
    module = cominModule;
  });
}