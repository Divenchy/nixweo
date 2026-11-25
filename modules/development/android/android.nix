# Android SDK from android-nixpkgs, exposed as packages.<system>.android-sdk
# (`nix build ~/nixweo#android-sdk`).
{inputs, ...}: {
  perSystem = {system, ...}: {
    packages.android-sdk = inputs.android-nixpkgs.sdk.${system} (sdkPkgs:
      with sdkPkgs; [
        build-tools-36-0-0
        cmdline-tools-latest
        emulator
        platform-tools
        platforms-android-36
        ndk-27-1-12297006
        cmake-3-22-1
        # System images for emulator
        system-images-android-34-google-apis-x86-64
      ]);
  };
}
