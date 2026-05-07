{ lib, ... }: 
let
  fb = { ... }: {
    services.filebrowser = {
      enable = true;
      port = 8001;
      address = "127.0.0.1";
    };
  };

  targetHosts = [ "cosmosserver" "cosmoslaptop" ];
in
{
  configurations.nixos = lib.genAttrs targetHosts (name: {
    module = fb;
  });
}