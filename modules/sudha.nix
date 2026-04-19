# ./modules/users/sudha.nix
{ ... }:
let
  # Define the core identity and CLI tools that Sudha needs everywhere
  baseHomeConfig = { pkgs, ... }: {
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
    ];

    # Standard Home Manager syntax for Git identity
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
  # ==========================================
  # TARGET 1: Sudha on Cosmos Laptop
  # ==========================================
  configurations.home."sudha@cosmoslaptop".system = "x86_64-linux";
  configurations.home."sudha@cosmoslaptop".module = baseHomeConfig;

  # ==========================================
  # TARGET 2: Sudha on Cosmos WSL (Optional Example)
  # ==========================================
  configurations.home."sudha@cosmos-wsl".system = "x86_64-linux";
  configurations.home."sudha@cosmos-wsl".module = baseHomeConfig;
}