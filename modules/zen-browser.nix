{ inputs, ... }:
let
  zen-browser = { pkgs, ... }: {
      home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
in
{
  configurations.home."sudha@cosmoslaptop".module = zen-browser;
}