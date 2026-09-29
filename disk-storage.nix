# {
#   disko.devices.disk.main = {
#     type = "disk";
#     device = "/dev/sda";
#     content = {
#       type = "gpt";
#       partitions = {

#         ESP = {
#           type = "EF00";
#           size = "500M";
#           content = {
#             type = "filesystem";
#             format = "vfat";
#             mountpoint = "/boot";
#             mountoptions = ["umask=0077"];
#           };
#         };

#         root = {
#           size = "100%";
#           content = {
#             type = "filesystem";
#             format = "ext4";
#             mountpoint = "/";
#           };
#         };
#       };
#     };
#   };
# }
{
  disk.devices.disk = {
    main = {
      type = "disk";
      device = "dev/sda";
      content = {
        type = "gpt";
        partitions = {
          # Загрузочный раздел
          ESP = {
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              moutpoint = "/boot";
              moutoptions = ["umask=0077"];
            };
          };
          # Шифрованный раздел (все остальное место) 
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
  };

  # LVM тома внутри luks раздела
  lvm_vg = {
    pool = {
      type = "lvm_vg";
      lvs = {
        # Раздел подкачки
        swap = {
          size = "8G";
          content = {
            type = "swap";
            resumeDevice = "true";
          };
        };
        # Корневой раздел
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      }; 
    };
  };
}