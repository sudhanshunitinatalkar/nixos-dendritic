# ./modules/features/zen-browser.nix
{ inputs, ... }:
{
  # ==========================================
  # PUSH TO: Sudha on Cosmos Laptop ONLY
  # ==========================================
  configurations.home."sudha@cosmoslaptop".module = { pkgs, ... }: {
    
    home.packages = [
      # Access the zen-browser flake output dynamically based on the system architecture
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}