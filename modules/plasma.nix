# ./modules/features/plasma.nix
{ inputs, ... }:
{
  # ==========================================
  # 1. PUSH TO NIXOS: System-Level Daemons & Packages
  # Target: cosmoslaptop
  # ==========================================
  configurations.nixos."cosmoslaptop".module = { pkgs, ... }:
  {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # KDE
      kdePackages.plasma-browser-integration
      kdePackages.kcalc 
      kdePackages.kcharselect 
      kdePackages.kclock 
      kdePackages.kcolorchooser 
      kdePackages.kolourpaint 
      kdePackages.ksystemlog 
      kdePackages.sddm-kcm 
      kdiff3 
      kdePackages.isoimagewriter 
      kdePackages.partitionmanager
      kdePackages.filelight
      kdePackages.kdeconnect-kde 
      # Non-KDE graphical packages
      hardinfo2 
      wayland-utils 
      wl-clipboard 
      
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}