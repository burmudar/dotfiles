{ pkgs, ...}:
{
  users.groups.libvirtd.members = ["william"];
  users.groups.kvm.members = ["william"];
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
    ovmf.packages = [ pkgs.OVMFFull.fd ];
  };
  programs.virt-manager.enable = true;
  environment.systemPackages = [ pkgs.virtiofsd ];
}
