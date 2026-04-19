{ inputs, ... }:
{
  configurations.home."sudha@cosmoslaptop".module = { pkgs, ... }: {
    home.packages = [
      # Access the zen-browser flake output dynamically based on the system architecture
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}