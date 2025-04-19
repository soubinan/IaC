#!/bin/bash

mkfs.xfs -L var-lib-cont -f /dev/disk/by-id/scsi-SDELL_PERC_H330_Adp_00425e16a49e38922f0086f557f098cd || echo "Unable to create filesystem, probably already exists"
udevadm settle
touch /etc/var-lib-containers-mount
exit
