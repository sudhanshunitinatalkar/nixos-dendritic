{ ... }:
{
  configurations.nixos."cosmosserver".module = {
    services.tailscale.enable = true;
  };
}