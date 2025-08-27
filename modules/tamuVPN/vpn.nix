{ lib, pkgs, ...}:

{
  system.activationScripts.installTAMUVPN = lib.fileContents ''
  chmod +x /home/weo/nixweo/modules/tamuVPN/cisco-secure-client-linux64-5.1.10.233-core-vpn-webdeploy-k9.sh
  sudo /home/weo/nixweo/modules/tamuVPN/cisco-secure-client-linux64-5.1.10.233-core-vpn-webdeploy-k9.sh
  '';
}
