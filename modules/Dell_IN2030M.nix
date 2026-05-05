{ inputs, lib, ... }:
{
  # We push this entire hardware + disk definition into the cosmos_server bucket
  configurations.nixos."cosmos_server".module = { config, modulesPath, ... }: {
    # 1. DISKO LAYOUT (1MB BIOS Boot + Remaining EXT4)
    # This replaces the need for manual 'fileSystems' entries or UUIDs.
    disko.devices = {
      disk = {
        main = {
          # Standard SATA hard drive path
          device = lib.mkDefault "/dev/sda"; 
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02"; # Required for GRUB on GPT (BIOS Boot partition)
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };

    # 2. CORE HARDWARE DRIVERS
    # These ensure the kernel can actually talk to your SATA and USB controllers.
    imports = [ 
      inputs.disko.nixosModules.disko
      (modulesPath + "/installer/scan/not-detected.nix") 
    ];

    boot.initrd.availableKernelModules = [ 
      "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" 
    ];
    boot.initrd.kernelModules = [ ];
    # Assuming Intel based on typical older Dell models. Change to kvm-amd if necessary.
    boot.kernelModules = [ "kvm-intel" ]; 
    boot.extraModulePackages = [ ];

    # 3. PLATFORM IDENTITY
    # This defines the architecture without hardcoding machine-specific IDs.
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}