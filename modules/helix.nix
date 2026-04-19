{ ... }:
{
  # ==========================================
  # PUSH TO: Sudha on Cosmos Laptop ONLY
  # ==========================================
  configurations.home."sudha@cosmoslaptop".module =
    { ... }:
    {
      programs.helix = {
        enable = true;
        settings = {
          keys.insert = {
            "C-c" = "normal_mode"; # Press Ctrl + C to escape instantly
          };
        };
      };
    };
}
