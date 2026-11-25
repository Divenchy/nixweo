# libvirt/QEMU VMs with SPICE.
{
  flake.modules.nixos.libvirt = {pkgs, ...}: {
    services.spice-vdagentd.enable = true;

    programs.dconf.enable = true;
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # VM
      qemu_kvm
      remmina
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      swtpm
      virtio-win
      win-spice
      adwaita-icon-theme
    ];
  };
}
