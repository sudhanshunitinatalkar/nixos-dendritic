{ ... }:
{
  configurations.nixos."cosmosserver".module = {
    services.tailscale.enable = true;
    services.tailscale.extraDaemonFlags = [ "--ssh" ];
  };
}