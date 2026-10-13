{
  lib,
  config,
  ...
}: let
  cfg = config.weo.hardware.cpu.amd;
in {
  options.weo.hardware.cpu.amd.enable = lib.mkEnableOption "AMD CPU tuning (kvm-amd, amd_pstate, microcode)";

  config = lib.mkIf cfg.enable {
    boot.kernelModules = ["kvm-amd"];
    boot.kernelParams = ["amd_pstate=active"];
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
