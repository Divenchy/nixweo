# Zen Browser: Firefox-based browser, official release builds via 0xc000022070/zen-browser-flake.
{inputs, ...}: {
  flake.modules.homeManager.zen-browser = {
    imports = [inputs.zen-browser.homeModules.beta];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      # Never lose tabs or spaces. Policies are locked: the settings UI can't turn them off.
      # Profiles are deliberately not declared here: Zen keeps its auto-created profile
      # (~/.config/zen/profiles.ini), and declaring one with a different path would open an empty profile.
      # Never set spacesForce/pinsForce: they overwrite the spaces and pins created in the browser.
      policies = {
        # Never clear history or sessions on shutdown (locks every privacy.clearOnShutdown.* off).
        SanitizeOnShutdown = false;
        Preferences = let
          locked = Value: {
            inherit Value;
            Status = "locked";
          };
        in {
          "browser.startup.page" = locked 3; # 3 = restore previous session
          "browser.sessionstore.resume_from_crash" = locked true;
          # -1 = always auto-restore after a crash, never show the "Start New Session" page.
          "browser.sessionstore.max_resumed_crashes" = locked (-1);
          "browser.sessionstore.interval" = locked 15000; # write session every 15s (Zen default 40s)
          "browser.privatebrowsing.autostart" = locked false; # permanent private mode saves no session
        };
      };
    };
  };
}
