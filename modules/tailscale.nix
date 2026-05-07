{ ... }:
let
  ts = { ... }:{
    services.tailscale.enable = true;
  };
in
{
  configurations.nixos."cosmosserver".module = ts;
  configurations.nixos."cosmoslaptop".module = ts;
}