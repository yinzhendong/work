#### samba

##### install samba
`yum install samba`

##### add windows directory to linux
`mount -t cifs -o username=administrator,password=a //192.168.1.111/tmp /home/nginx/vod/`

##### view windows directory
`smbclient //192.168.1.111/d$ -U administrator`

##### linux to windows
```
vi /etc/samba/smb.conf

security = share

[public]
comment = Public Stuff
path = /home/samba
public = yes
writable = yes
```
