{ inputs, config, pkgs, ... }:

{
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "192.168.204.201:/mnt/pve/hdd";
    where = "/mnt/hdd";
  }];
  systemd.automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
          TimeoutIdleSec = "600";
      };
      where = "/mnt/hdd";
  }];
}
