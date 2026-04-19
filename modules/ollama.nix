{ ... }:
let
  ollama = { pkgs, ... }:
  {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
    };
  };
in
{
  configurations.nixos."cosmoslaptop".module = ollama;
}
