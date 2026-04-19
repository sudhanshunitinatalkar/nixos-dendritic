# ./modules/features/hermes.nix
{ inputs, lib, ... }:
let
  # 1. Define your AI Brain once to keep it DRY (Don't Repeat Yourself)
  hermesSettings = {
    model = {
      default = "qwen2.5:3b"; # Using 2.5 3B as the standard local weight
      provider = "ollama";
      base_url = "http://127.0.0.1:11434";
    };
    terminal.backend = "local";
    toolsets = [ "all" ];
  };

  # Helper for the fast, test-skipped package
  getFastHermes = pkgs: inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    doCheck = false;
    doInstallCheck = false;
  });
in
{
  # ==========================================
  # SYSTEM LEVEL: The Persistent Daemon
  # Target: cosmoslaptop
  # ==========================================
  configurations.nixos."cosmoslaptop".module = { pkgs, ... }: {
    imports = [ inputs.hermes-agent.nixosModules.hermes-agent ];

    users.users.sudha.extraGroups = [ "hermes" ];

    services.hermes-agent = {
      enable = true;
      package = getFastHermes pkgs;
      config = hermesSettings; # Injects into /var/lib/hermes/.hermes/config.yaml [cite: 344]
      skills.bundled.enable = false;
    };
  };

  # ==========================================
  # USER LEVEL: The Home Manager Identity
  # Target: sudha@cosmoslaptop
  # ==========================================
  configurations.home."sudha@cosmoslaptop".module = { pkgs, ... }: {
    # Install CLI to user profile
    home.packages = [ (getFastHermes pkgs) ];

    # DIRECT INJECTION: Writes the config file exactly where the CLI expects it
    home.file.".hermes/config.yaml".text = builtins.toJSON hermesSettings;

    # Optional: Ensure the memory and logs directories exist
    home.file.".hermes/.keep".text = ""; 
  };
}