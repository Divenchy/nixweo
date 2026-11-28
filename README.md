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

The flake uses the [dendritic pattern](https://github.com/mightyiam/dendritic):
`flake.nix` only loads the inputs pinned by [tack](#dependencies-tack), and every `.nix` file under `modules/` is a
[flake-parts](https://flake.parts) module, loaded automatically by
[import-tree](https://github.com/vic/import-tree). Each file is one feature and
publishes NixOS and/or home-manager modules as `flake.modules.nixos.<name>` /
`flake.modules.homeManager.<name>`. Hosts and users import the features they want.

```
flake.nix                      # inputs from .tack; outputs = import-tree ./modules
.tack/                         # tack pins: pins.toml (edit), pins.lock.json (generated), default.nix (resolver)
modules/
  flake/                       # flake-parts setup, nixpkgs overlays
  hosts/
    nixweo/                    # nixosConfigurations.nixweo: desktop/laptop, full environment
    nixweosl/                  # nixosConfigurations.nixweosl: WSL, terminal-only
  users/
    weo/                       # user + home-manager config for nixweo
    nixweosl/                  # user + home-manager config for WSL
  system/
    base/ nix/ home-manager/ wsl/ fonts/ keyd/ docker/ libvirt/
    hardware/                  # opt-in hardware profiles (all off by default)
  development/
    zsh/                       # zsh.nix + plugins/
    weovim/                    # Neovim (nvf): weovim.nix, _nvim/_plugins/_remaps.nix, lua/, refactor-queries/
    emacs/ starship/ git/ direnv/
    android/                   # packages.<system>.android-sdk (android-nixpkgs)
    claude-code/               # Claude Code tooling + _vexp/ derivation
    packages/                  # shared CLI tools, dev libs, languages (+ _ada_language_server.nix)
    devshells/                 # devShells.<system>.* (+ _<shell>.nix, haskell.envrc)
  desktop/
    desktop.nix                # bundles every desktop app below into nixos.desktop / homeManager.desktop
    hyprland/                  # hyprland.nix, config/*.lua, scripts/
    niri/                      # niri.nix + config.kdl
    noctalia/ noctalia-greeter/ luciole/ zen-browser/
    wezterm/ stylix/ (+ wallpapers/) gtk-qt/
    xserver/ audio/ bluetooth/ printing/ godot/ apps/
hosts/nixweo/                  # UNTRACKED: hardware-configuration.nix, optional local.nix
```

Each program owns one folder holding its module and every file it uses (Lua,
themes, scripts, plugins, derivations). Inside a program folder, `.nix` files
that are not flake-parts modules (plain functions, derivations, devShells) start
with `_` so import-tree skips them.

To add a program, create `modules/<category>/<program>/<program>.nix` that sets
`flake.modules.nixos.<program>` (and/or `homeManager.<program>`), put its files
next to it, then add it to the `imports` of the host (`modules/hosts/<host>/`),
user (`modules/users/<user>/`) or bundle (`modules/desktop/desktop.nix`) that
should get it. New files must be `git add`ed before git-ref builds see them.

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
   mkdir -p hosts/nixweo
   sudo nixos-generate-config --root /mnt --show-hardware-config \
     > hosts/nixweo/hardware-configuration.nix
   ```

   This file should only contain what `nixos-generate-config` produces (disks,
   kernel modules, platform). Put hand-written hardware tuning in
   `modules/system/hardware/` and turn it on from `local.nix`.

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
mkdir -p hosts/nixweo
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

Everything specific to one kind of hardware lives in `modules/system/hardware/` behind
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

To add support for new hardware, add a module to `modules/system/hardware/` that sets
`flake.modules.nixos.<name>` with an `enable` option, import it in
`modules/hosts/nixweo/nixweo.nix`, and turn it on in that machine's `local.nix`.

## Packages

- **Shared by both hosts:** `modules/development/packages/packages.nix`, a home-manager module
  with three groups. Each is on by default and can be turned off per host:

  ```nix
  weo.packages.cli.enable = false;     # CLI tools
  weo.packages.devLibs.enable = false; # dev libs, tooling, texlive
  weo.packages.langs.enable = false;   # languages and their tooling
  ```

  The default Zig is `zigpkgs."0.17.0"`. `zigmaster` runs Zig master.
  `ada_language_server` is only installed on x86_64 (upstream ships an
  x86_64-only binary).

- **User-specific:** add to `home.packages` in `modules/users/<user>/<user>.nix`. Desktop
  apps, WM tooling, fonts and hardware utilities belong to `weo`; WSL-only
  extras go to `nixweosl`.

- **System-wide:** `environment.systemPackages` in `modules/hosts/<host>/<host>.nix`.

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

## Dependencies (tack)

Inputs are managed by [tack](https://docs.manic.systems/tack), not by flake
`inputs`. `flake.nix` has no `inputs` block and there is no meaningful
`flake.lock`: `nix flake update` does nothing. Use the `tack` CLI (installed on
both hosts) from the repo root instead.

| File                   | What it is                                                   |
| ---------------------- | ------------------------------------------------------------ |
| `.tack/pins.toml`      | Pin definitions (URL, `follows`). Edit by hand or with `tack`. |
| `.tack/pins.lock.json` | Locked revisions, written by `tack update`. Commit it.       |
| `.tack/default.nix`    | Resolver managed by tack. Don't edit.                        |

```sh
cd ~/nixweo
tack look                     # show available updates, change nothing
tack look -v nixpkgs          # same, with the commit list
tack update                   # update every pin
tack update weomacs-flake     # update a single pin
tack update --exclude hyprland  # update all except one
tack undo                     # revert the last tack change (redo: tack redo)
sudo nixos-rebuild switch --flake path:.#nixweo
```

Commit `.tack/pins.lock.json` afterwards so every machine builds the same versions.

Adding, removing and inspecting inputs:

```sh
tack add <name> <url>         # e.g. tack add foo github:owner/foo; available as inputs.foo
tack rm <name>
tack tree                     # every pin's inputs and what they follow
tack freeze nixpkgs           # hold a pin at its locked rev (tack unfreeze to release)
```

To make a new input reuse this config's nixpkgs (like `inputs.x.inputs.nixpkgs.follows`),
add a `follows` table under it in `.tack/pins.toml`:

```toml
[inputs.luciole]
url = "github:noctalia-dev/luciole"

[inputs.luciole.follows]
nixpkgs = "nixpkgs"
```

Leave `follows` off for inputs that ship a binary cache (`sidra`, `tack`): the
cache only has builds made against their own nixpkgs.

## Updating

Update pins as in [Dependencies](#dependencies-tack), then rebuild.

Old generations are garbage-collected weekly (older than 8 days). To roll back, run
`sudo nixos-rebuild switch --rollback` or pick an older entry in GRUB.

## Troubleshooting

- **`Missing hardware-configuration.nix for this host.`** You either built with a
  git reference (use `path:`), or this machine has no hardware config yet. See
  step 3 of the install.
- **`opening file ".../flake.lock": Permission denied`** happens when
  `sudo nixos-rebuild` writes the (now empty) lock file and leaves it owned by
  root. Fix it with `sudo chown $USER flake.lock`.
- **`The option ... is defined multiple times`** after enabling a hardware profile
  means `hardware-configuration.nix` still contains hand-written settings that
  the profile now provides. Regenerate the file (step 3) so it only holds
  generated content.
- **New files aren't picked up by `nix develop`.** Git references only see
  tracked files, so `git add` new files first (or use `path:`).
