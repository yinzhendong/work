#### samba

##### install samba
`yum install samba`

##### add windows directory to linux
`mount -t cifs -o username=administrator,password=a //192.168.1.111/tmp /home/nginx/vod/`

##### view windows directory
`smbclient //192.168.1.111/d$ -U administrator`