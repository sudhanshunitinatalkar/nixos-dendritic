{ ... }:
let
  sudha = { pkgs, ... }:{
    nixpkgs.config.allowUnfree = true;
    home.username = "sudha";
    home.homeDirectory = "/home/sudha";
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      tree
      util-linux
      wget
      curl
      git
      gptfdisk
      htop
      fastfetch
      android-tools
      sops
      pciutils
      mosquitto
      nixd
      nil
      cloudflared
      cachix
      python3
      zed-editor
      telegram-desktop
      espeak-ng
      uv
      steam-run
      prusa-slicer
    ];
    programs.git = {
      enable = true;
      settings.user = {
        name = "sudhanshunitinatalkar";
        email = "atalkarsudhanshu@proton.me";
      };
    };
  };
in
{
  configurations.home."sudha@cosmoslaptop".system = "x86_64-linux";
  configurations.home."sudha@cosmoslaptop".module = sudha;

  # configurations.home."sudha@cosmos-wsl".system = "x86_64-linux";
  # configurations.home."sudha@cosmos-wsl".module = baseHomeConfig;
}
