{
  lib,
  config,
  ...
}: let
  cfg = config.weo.hardware.asusLaptop;
in {
  options.weo.hardware.asusLaptop.enable = lib.mkEnableOption "ASUS laptop services (asusd, supergfxd, TLP, acpi_call)";

  config = lib.mkIf cfg.enable {
    boot.kernelModules = ["acpi_call"];
    boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];

    services = {
      asusd.enable = true;
      supergfxd.enable = true;

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          # AMD specific
          CPU_DRIVER_OPMODE_ON_AC = "active";
          CPU_DRIVER_OPMODE_ON_BAT = "active";

          # AMD P-State EPP (Energy Performance Preference)
          CPU_SCALING_MIN_FREQ_ON_AC = 400000;
          CPU_SCALING_MAX_FREQ_ON_BAT = 2000000;

          # Platform profile (for AMD laptops)
          PLATFORM_PROFILE_ON_AC = "balanced";
          PLATFORM_PROFILE_ON_BAT = "low-power";

          # Runtime PM for GPU power saving
          RUNTIME_PM_ON_AC = "auto";
          RUNTIME_PM_ON_BAT = "auto";

          # Cooling policy
          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;
        };
      };
    };
  };
}
