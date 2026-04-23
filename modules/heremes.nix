# ./modules/hermes.nix
{ inputs, ... }:
{
  configurations.nixos."cosmoslaptop".module = { pkgs, ... }: 
  {
    imports = [ inputs.hermes-agent.nixosModules.default ];
    users.users.sudha.extraGroups = [ "hermes" ];
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true; 
    };
  };
}