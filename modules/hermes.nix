# ./modules/hermes.nix
{ inputs, ... }:
{
  configurations.nixos."cosmoslaptop".module = { pkgs, ... }: 
  let
    fastHermes = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      doCheck = false;
      doInstallCheck = false;
    });
  in
  {
    imports = [ inputs.hermes-agent.nixosModules.default ];

    # 1. Clearance for your user
    users.users.sudha.extraGroups = [ "hermes" ];

    # 2. The Background Daemon
    services.hermes-agent = {
      enable = true;
      package = fastHermes;
      # Required so the daemon doesn't crash on its first boot
      # environmentFiles = [ "/var/lib/hermes/env" ];
    };

    # 3. The Terminal CLI
    environment.systemPackages = [ fastHermes ];

    # # 4. THE BRIDGE: Forces CLI and Daemon to use the same config folder
    # environment.variables = {
    #   HERMES_HOME = "/var/lib/hermes/.hermes";
    # };

    # 5. Initialize the system files
    # systemd.tmpfiles.rules = [
    #   "f /var/lib/hermes/env 0600 hermes hermes - OLLAMA=local"
    # ];
  };
}