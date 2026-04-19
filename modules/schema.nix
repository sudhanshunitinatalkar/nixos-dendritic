{ lib, config, inputs, ... }:
{
  # ---------------------------------------------------------
  # 1. THE SCHEMA 
  # ---------------------------------------------------------
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  options.configurations.home = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
        options.system = lib.mkOption {
          type = lib.types.str;
          default = "x86_64-linux"; 
        };
      }
    );
  };

  # ---------------------------------------------------------
  # 2. THE BUILDERS 
  # ---------------------------------------------------------
  config.flake = {
    # Build NixOS Systems
    nixosConfigurations = lib.flip lib.mapAttrs config.configurations.nixos (
      name: { module }: lib.nixosSystem { modules = [ module ]; }
    );

    # Build Home Manager Environments
    homeConfigurations = lib.flip lib.mapAttrs config.configurations.home (
      name: cfg: inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${cfg.system};
        extraSpecialArgs = { inherit inputs; };
        modules = [ cfg.module ];
      }
    );

    # ---------------------------------------------------------
    # 3. THE CHECKS (Dry-Run Verifications)
    # ---------------------------------------------------------
    # We use lib.mkMerge to safely combine both lists of checks
    checks = lib.mkMerge [
      (
        lib.mkMerge (
          lib.mapAttrsToList (
            name: nixos: {
              ${nixos.config.nixpkgs.hostPlatform.system} = {
                "configurations:nixos:${name}" = nixos.config.system.build.toplevel;
              };
            }
          ) config.flake.nixosConfigurations
        )
      )
      (
        lib.mkMerge (
          lib.mapAttrsToList (
            name: home: {
              ${home.pkgs.stdenv.hostPlatform.system} = {
                "configurations:home:${name}" = home.activationPackage;
              };
            }
          ) config.flake.homeConfigurations
        )
      )
    ];
  };
}