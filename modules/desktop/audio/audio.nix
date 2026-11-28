# PipeWire (ALSA, Pulse, JACK) with low-latency clock and the libcamera monitor disabled.
{
  flake.modules.nixos.audio = {pkgs, ...}: {
    services = {
      # Audio
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        wireplumber = {
          enable = true;
          configPackages = [
            (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-disable-camera.conf" ''
              wireplumber.profiles = {
                main = {
                  monitor.libcamera = disabled
                }
              }
            '')
          ];
        };

        extraConfig.pipewire."92-low-latency" = {
          context.properties = {
            default.clock = {
              rate = 48000;
              quantum = 1024;
              min-quantum = 512;
              max-quantum = 2048;
            };
          };
        };
      };
    };

    # Audio
    security.rtkit.enable = true;
    # JACK apps: launch via `pw-jack <app>` (jack.enable deprecated, set global LD_LIBRARY_PATH).
    environment.systemPackages = [pkgs.pipewire.jack];
  };
}
