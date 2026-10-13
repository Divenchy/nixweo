{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.weo.hardware.nvidiaPrime;
in {
  options.weo.hardware.nvidiaPrime = {
    enable = lib.mkEnableOption "NVIDIA dGPU with PRIME offload";
    nvidiaBusId = lib.mkOption {
      type = lib.types.str;
      example = "PCI:1:0:0";
    };
    amdgpuBusId = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    intelBusId = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.amdgpuBusId != null) != (cfg.intelBusId != null);
        message = "weo.hardware.nvidiaPrime: set exactly one of amdgpuBusId or intelBusId.";
      }
    ];

    boot.kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];

    services.xserver.videoDrivers =
      lib.optional (cfg.amdgpuBusId != null) "amdgpu"
      ++ lib.optional (cfg.intelBusId != null) "modesetting"
      ++ ["nvidia"];

    hardware = {
      nvidia = {
        package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        open = false;
        nvidiaSettings = true;

        prime =
          {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            inherit (cfg) nvidiaBusId;
          }
          // lib.optionalAttrs (cfg.amdgpuBusId != null) {inherit (cfg) amdgpuBusId;}
          // lib.optionalAttrs (cfg.intelBusId != null) {inherit (cfg) intelBusId;};
      };

      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver # hardware accel in general
          cudatoolkit
          ocl-icd
          opencl-headers
        ];
      };
    };
  };
}
