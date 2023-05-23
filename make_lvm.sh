mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
 

sudo yum install lvm2 и device-mapper -y
sudo pvcreate /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf

sudo vgcreate vg_test1 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf

sudo lvcreate vg_test1 -n01 -L200M
sudo lvcreate vg_test1 -n02 -L200M


sudo mkdir /mnt/var
sudo mkdir /mnt/home
sudo mkdir /mnt/snap_test


sudo mkfs.ext4 /dev/mapper/vg_test1-01 
sudo mkfs.ext4 /dev/mapper/vg_test1-02

sudo mount /dev/mapper/vg_test1-01 /mnt/var
sudo mount /dev/mapper/vg_test1-02 /mnt/home

#mirror
sudo lvcreate -L 50M -m1 -n mirror vg_test1
sudo mkfs.xfs /dev/vg_test1/mirror
sudo mount /dev/vg_test1/mirror /mnt/var
sudo cp -aR /var/log/* /mnt/var/ # rsync -avHPSAX /var/log /mnt/var
sudo ls /mnt/var
sudo ls /var/log

#snap
sudo touch /mnt/home/file{1..9}
sudo lvcreate -L 50M -s -n snap1 /dev/mapper/vg_test1-02
sudo mount /dev/vg_test1/snap1 /mnt/snap_test
sudo ls /mnt/snap_test
sudo rm -f /mnt/home/file{1..9}
sudo ls /mnt/home
sudo umount /mnt/snap_test
sudo umount /mnt/home
sudo lvconvert --merge /dev/vg_test1/snap1
sudo mount /dev/mapper/vg_test1-02 /mnt/home
sudo ls /mnt/home







