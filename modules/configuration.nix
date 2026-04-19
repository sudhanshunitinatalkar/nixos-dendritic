{ ... }:
let
  cosmos = { pkgs, ... }: {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      trusted-users = [ "root" "sudha" ];
    };
    
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "25.11";

    # Common Boot Settings (EFI)
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    hardware.bluetooth.enable = true;

    networking = {
      networkmanager.enable = true;
      firewall.enable = false;
    };

    time.timeZone = "Asia/Kolkata";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    users.users.sudha = {
      isNormalUser = true;
      extraGroups = [ "wheel" "dialout" "docker" ];
    };

    services = {
      printing.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
      };
      openssh.enable = true;
    };

    environment.systemPackages = with pkgs; [
      tree util-linux vim wget curl git 
      gptfdisk htop pciutils home-manager
    ];
  };
in
{
  # ==========================================
  # DEPLOYMENT TARGET: Cosmos Laptop
  # ==========================================
  configurations.nixos."cosmoslaptop".module = {
    # We use 'imports' to combine the universal function with our static overrides
    imports = [
      cosmos
      { networking.hostName = "cosmoslaptop"; }
    ];
  };
}