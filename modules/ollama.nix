{ ... }:
let
  ollama = { pkgs, ... }:
  {
    services.ollama = {
      enable = true;
    };
  };
in
{
  configurations.nixos."cosmoslaptop".module = {
    imports = [ 
      ollama 
      # Wrap this in the same way!
      ({ pkgs, ... }: {
        services.ollama.package = pkgs.ollama-cuda;
      })
    ];
  };
}