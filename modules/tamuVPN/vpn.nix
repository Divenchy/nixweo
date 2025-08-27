{ lib, pkgs, ...}:

{
  system.activationScripts.installTAMUVPN = lib.fileContents ''
  chmod +x ./cisco-secure-client-linux64-5.1.10.233-core-vpn-webdeploy-k9.sh
  sudo ./cisco-secure-client-linux64-5.1.10.233-core-vpn-webdeploy-k9.sh
  '';
}
