## mke2fs
```
Date:2016-04-15
```

##### purpose
```
To solve the mkfs.ext4 not support bigger than 16T problem.
```
##### resolution
```
1. use lvm to create total space and initlization by mke2fs
```
##### caution
```
1. use the mke2fs firt in less than 16T situation, else extend will lose all old data!!!
2. bigger than 16T can not support online extend, unmount first!
3. mke2fs -i parameter
```
##### scene
```
/dev/sdb	8T
/dev/sdc	8T
/dev/sdd	8T
/dev/sde	8T
/dev/sdf	8T
```
##### procedure
```
1. first use lvm make lv_data that use /dev/sdb+/dev/sdc+/dev/sdd+/dev/sde total 32T size
2. add /dev/sdf to pv, then extend lv_data from 32T to 40T
```
##### command log
```
pvcreate /dev/sdb
pvcreate /dev/sdc
pvcreate /dev/sdd
pvcreate /dev/sde

vgcreate data /dev/sdb /dev/sdc /dev/sdd /dev/sde

lvcreate -n lv_data -l 8388604 /dev/data

git clone git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
cd e2fsprogs/
./configure
make
make instal
mke2fs -O 64bit,has_journal,extents,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize -i 2097152 /dev/data/lv_data

mkdir /data
mount /dev/data/lv_data /data

vi /etc/fstab

pvcreate /dev/sdf
vgextend data /dev/sdf
lvextend -l 10485755 /dev/data/lv_data
umount /data
e2fsck -f /dev/data/lv_data
resize2fs /dev/data/lv_data
```
