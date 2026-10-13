# nixweo

A flake-based NixOS configuration for two hosts:

| Host       | What it is                                      | User       |
| ---------- | ----------------------------------------------- | ---------- |
| `nixweo`   | Desktop/laptop install (Hyprland, Stylix, etc.) | `weo`      |
| `nixweosl` | NixOS-WSL on Windows                            | `nixweosl` |

The configuration does not depend on any one machine. Each machine keeps its own
untracked `hardware-configuration.nix` (and optionally a `local.nix`), so the
repo can be built on any machine without breaking the others.

## Important: always build with `path:`

`hosts/nixweo/hardware-configuration.nix` and `hosts/nixweo/local.nix` are
**gitignored**. A normal flake reference (`.#nixweo`, `~/nixweo#nixweo`) is a
`git+file` reference, and it only sees files that git tracks. The build will
stop with:

```
error: Missing hardware-configuration.nix for this host.
```

Use a `path:` reference instead, which includes untracked files:

```sh
sudo nixos-rebuild switch --flake path:$HOME/nixweo#nixweo
```

Also name the host explicitly. The hostnames (`weo2go`, and `nixos` on WSL)
don't match the flake output names, so `nixos-rebuild` can't pick the host
automatically.

## Layout

```
flake.nix                      # inputs, nixosConfigurations, devShells (per-system)
hosts/
  nixweo/
    configuration.nix          # system config for the desktop/laptop host
    home.nix                   # home-manager config: desktop apps, WM, fonts, IDEs
    hardware-configuration.nix # UNTRACKED, generated per machine
    local.nix                  # UNTRACKED, optional per-machine hardware profiles
    packages/                  # host-only package derivations (godot 4.6)
  nixweosl/
    configuration.nix          # NixOS-WSL system config
    home.nix                   # WSL-only packages
modules/
  common/
    packages.nix               # shared CLI tools, dev libs, languages (home-manager)
    local-hardware.nix         # loads the untracked hardware-configuration.nix
  hardware/                    # opt-in hardware profiles (all off by default)
    cpu-amd.nix
    nvidia-prime.nix
    asus-laptop.nix
  zsh/  weovim/  wezterm/  hyprland/
devshells/                     # nix develop environments
derivs/                        # standalone derivations (ada_language_server, ...)
resources/                     # wallpapers, waybar, starship, zsh plugins, ...
```

## Building on this machine

```sh
cd ~/nixweo
sudo nixos-rebuild switch --flake path:.#nixweo

# Build without activating (useful to test changes)
nixos-rebuild build --flake path:.#nixweo

# Activate on next boot only
sudo nixos-rebuild boot --flake path:.#nixweo
```

`hosts/nixweo/hardware-configuration.nix` and `hosts/nixweo/local.nix` already
exist here. Don't delete them; they aren't stored in git.

## Installing on a new (bare-metal) machine

These steps assume a UEFI machine. The bootloader is GRUB with `efiSupport` and
`device = "nodev"`.

1. **Boot the NixOS installer**, then partition and format the disks and mount them at `/mnt`
   (root on `/mnt`, EFI partition on `/mnt/boot`). See the
   [NixOS manual](https://nixos.org/manual/nixos/stable/#sec-installation-manual).

2. **Clone the repo:**

   ```sh
   nix-shell -p git
   git clone https://github.com/Divenchy/nixweo /mnt/home/weo/nixweo
   cd /mnt/home/weo/nixweo
   ```

3. **Generate this machine's hardware configuration** into the host directory:

   ```sh
   sudo nixos-generate-config --root /mnt --show-hardware-config \
     > hosts/nixweo/hardware-configuration.nix
   ```

   This file should only contain what `nixos-generate-config` produces (disks,
   kernel modules, platform). Put hand-written hardware tuning in
   `modules/hardware/` and turn it on from `local.nix`.

4. **(Optional) Create `hosts/nixweo/local.nix`** to turn on hardware profiles that
   match the machine. Skip it for a generic machine; without it, no profiles are
   enabled. See [Hardware profiles](#hardware-profiles).

5. **Install:**

   ```sh
   sudo nixos-install --flake path:/mnt/home/weo/nixweo#nixweo
   ```

   If the installer complains about experimental features, add
   `--option experimental-features "nix-command flakes"`.

6. **Set the user password** (the installer only asks for root's), then reboot:

   ```sh
   sudo nixos-enter --root /mnt -c 'passwd weo'
   sudo nixos-enter --root /mnt -c 'chown -R weo:users /home/weo/nixweo'
   reboot
   ```

From then on, rebuild as described in
[Building on this machine](#building-on-this-machine).

### Switching an existing NixOS install to this config

Same idea without the installer. Clone to `~/nixweo`, copy the generated
hardware config into the host directory, and switch:

```sh
git clone https://github.com/Divenchy/nixweo ~/nixweo
cd ~/nixweo
sudo nixos-generate-config --show-hardware-config > hosts/nixweo/hardware-configuration.nix
sudo nixos-rebuild switch --flake path:.#nixweo
```

## Installing the WSL host (`nixweosl`)

WSL needs no `hardware-configuration.nix`; NixOS-WSL provides that layer.

1. Install NixOS-WSL by following the
   [NixOS-WSL instructions](https://github.com/nix-community/NixOS-WSL), then open it.

2. Clone and build. Because this config changes the default user from `nixos`
   to `nixweosl`, use `boot` instead of `switch`:

   ```sh
   nix-shell -p git
   git clone https://github.com/Divenchy/nixweo ~/nixweo
   cd ~/nixweo
   sudo nixos-rebuild boot --flake path:.#nixweosl
   ```

3. From PowerShell, restart the distro so the new default user takes effect:

   ```powershell
   wsl -t NixOS
   wsl -d NixOS --user root exit
   wsl -t NixOS
   ```

Later rebuilds: `sudo nixos-rebuild switch --flake path:$HOME/nixweo#nixweosl`.

## Hardware profiles

Everything specific to one kind of hardware lives in `modules/hardware/` behind
an option that is **off by default**. A machine with different hardware (an
Intel CPU, AMD-only graphics, a non-ASUS laptop) gets none of it unless it opts in.

| Option                               | What it enables                                                                |
| ------------------------------------ | ------------------------------------------------------------------------------ |
| `weo.hardware.cpu.amd.enable`        | `kvm-amd`, `amd_pstate=active`, AMD microcode                                  |
| `weo.hardware.nvidiaPrime.enable`    | NVIDIA driver, PRIME offload, NVreg params, VA-API/CUDA/OpenCL, `videoDrivers` |
| `weo.hardware.asusLaptop.enable`     | asusd, supergfxd, TLP power profile, `acpi_call`                               |

Turn them on in the untracked `hosts/nixweo/local.nix`. For example, this machine
(ASUS laptop, AMD CPU + iGPU, NVIDIA dGPU) uses:

```nix
{
  weo.hardware = {
    cpu.amd.enable = true;
    asusLaptop.enable = true;
    nvidiaPrime = {
      enable = true;
      amdgpuBusId = "PCI:101:0:0"; # or intelBusId on an Intel + NVIDIA machine
      nvidiaBusId = "PCI:100:0:0";
    };
  };
}
```

**Finding bus IDs:** run `lspci -D | grep -E 'VGA|3D'`. `lspci` prints the bus in
**hex** and NixOS expects **decimal**. For example, `0000:64:00.0` becomes
`PCI:100:0:0`.

To add support for new hardware, add a module to `modules/hardware/` with an
`enable` option, import it from `modules/hardware/default.nix`, and turn it on in
that machine's `local.nix`.

## Packages

- **Shared by both hosts:** `modules/common/packages.nix`, a home-manager module
  with three groups. Each is on by default and can be turned off per host:

  ```nix
  weo.packages.cli.enable = false;     # CLI tools
  weo.packages.devLibs.enable = false; # dev libs, tooling, texlive
  weo.packages.langs.enable = false;   # languages and their tooling
  ```

  The default Zig is `zigpkgs."0.17.0"`. `zigmaster` runs Zig master.
  `ada_language_server` is only installed on x86_64 (upstream ships an
  x86_64-only binary).

- **Host-specific:** add to `home.packages` in `hosts/<host>/home.nix`. Desktop
  apps, WM tooling, fonts and hardware utilities belong in `nixweo`; WSL-only
  extras go in `nixweosl`.

- **System-wide:** `environment.systemPackages` in `hosts/<host>/configuration.nix`.

## Dev shells

Dev shells are generated for `x86_64-linux` and `aarch64-linux`. They don't depend on
a host configuration, so they work with an ordinary git reference:

| Shell            | Contents                                         | Alias                        |
| ---------------- | ------------------------------------------------ | ---------------------------- |
| `zig-ray-lib`    | Zig master, zls, raylib, X11 libs                | `devZigRaylib`, `devZigGame` |
| `graphics`       | Zig, Rust, Odin, Vulkan/OpenGL/SDL2, renderdoc   | `devGraphics`                |
| `elixir-phoenix` | FHS env with Elixir, Erlang, Node, PostgreSQL 18 | —                            |

```sh
nix develop ~/nixweo#graphics --command zsh
```

Neovim (weovim) is installed system-wide on both hosts, so it's available inside
every shell.

## Updating

```sh
cd ~/nixweo
nix flake update                # all inputs
nix flake update weomacs-flake  # a single input
sudo nixos-rebuild switch --flake path:.#nixweo
```

Commit `flake.lock` afterwards so every machine builds the same versions.

Old generations are garbage-collected weekly (older than 8 days). To roll back, run
`sudo nixos-rebuild switch --rollback` or pick an older entry in GRUB.

## Troubleshooting

- **`Missing hardware-configuration.nix for this host.`** You either built with a
  git reference (use `path:`), or this machine has no hardware config yet. See
  step 3 of the install.
- **`opening file ".../flake.lock": Permission denied`** happens when
  `sudo nixos-rebuild` rewrites the lock file and leaves it owned by root. Fix it
  with `sudo chown $USER flake.lock`.
- **`The option ... is defined multiple times`** after enabling a hardware profile
  means `hardware-configuration.nix` still contains hand-written settings that
  the profile now provides. Regenerate the file (step 3) so it only holds
  generated content.
- **New files aren't picked up by `nix develop`.** Git references only see
  tracked files, so `git add` new files first (or use `path:`).
