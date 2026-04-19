{ ... }:
{
  # ==========================================
  # 1. PUSH TO NIXOS: System-Level Daemons & Packages
  # Target: cosmoslaptop
  # ==========================================
  configurations.nixos."cosmoslaptop".module =
    { pkgs, ... }:
    {
      services.ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
      };
    };
}
