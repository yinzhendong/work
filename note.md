#### note

##### exact bz2 xz file
```
bzip2 -d **.tar.bz2
xz -d **.tar.xz
```

##### yum localinstall
```
yum localinstall mysql57-community-release-el6-7.noarch.rpm
```
##### find
`find ./Discory\ Channel/ -exec convmv -f GBK -t UTF-8 --notest ./* {} \;`

##### seq
`seq -f dir%3g | xargs mkdir`

`seq -s ":" 1 9`

`mkdir {1..9}`

##### Apache rewrite
```
RewriteEngine On
RewriteCond %{HTTP_REFERER} !^http://a.com/.*$ [NC]
RewriteCond %{HTTP_REFERER} !^http://a.com$ [NC]
RewriteCond %{HTTP_REFERER} !^http://www.a.com/.*$ [NC]
RewriteCond %{HTTP_REFERER} !^http://www.a.com$ [NC]
RewriteRule .*\.(mp4|gif|jpg|png|swf)$ http://www.a.com/images/boful_default_img.png [R,NC]
```
##### Add time and user to history cmd

```
echo 'export HISTTIMEFORMAT="%F %T `whoami` "' >> /etc/profile
source /etc/profile
```
##### yum install handbrake
```
wget http://pkgrepo.linuxtech.net/el6/release/linuxtech.repo -P /etc/yum.repos.d/
yum install handbrake-cli
```
##### RPM
```
# query rpm package
rpm -qa | grep packagename

# remove rpm package
rpm -e libmediainfo0-0.7.68-313.1.x86_64
```
##### /etc/issue
```
[root@tmp workspace]# more /etc/issue
CentOS release 6.7 (Final)
Kernel \r on an \m
```
##### mysql skip-grant (for forgot root password)
```
vi /etc/my.cnf
#skip-grant
```
##### monitor msyql
```
mytop
mysqlreport
```
##### sql
```
alter table resource click_number not null;
alter table resource add column recommend_number int(11);

mysqldump -uroot -proot -B enzodemo --table resource_library_tags > resource_library_tags.sql
mysqldump -opt -d enzodemo -uroot -proot > enzo.sql

select database();

show create table category;

mysql -uroot -proot -e "create database mms default character set utf8"
mysql -uroot -proot -D mms -e "source /root/mms.sql"
```


##### insert

`insert permission values('','','')`

##### install nginx
```
wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
rpm -ivh nginx-release-centos-6-0.el6.ngx.noarch.rpm
yum install nginx
```
##### config nginx for file server
`vi /etc/nginx/conf.d/default.conf`

```
autoindex on;
autoindex_exact_size off;
autoindex_localtime on;
```

##### Git Skills

**git initialization**

`git init`

**git commit**

```
git add file1 file2 file3
git commit -m "commit comment"
```

**git remote github**

```
git remote add origin git@github.com:TrentYin/work.git
git push -u origin master
```
**windows下git add warning: LF will be replaced by CRLF 处理方法**

```
rm -rf .git
git config --global core.autocrlf false
git init

```
##### tomcat session timeout

`vi modify web.xml`
```
<session-config>
        <session-timeout>30</session-timeout>
</session-config>
```

##### mysql grant
```
grant all on *.* to root@'%' identified by 'password' with grant option;
flush privileges;
```
##### mysql max_allowed_packet
```
mysql> show VARIABLES like '%max_allowed_packet%';
+--------------------------+------------+
| Variable_name            | Value      |
+--------------------------+------------+
| max_allowed_packet       | 1048576    |
| slave_max_allowed_packet | 1073741824 |
+--------------------------+------------+
2 rows in set (0.00 sec)
-------------------------------------------------
[root@10-6-8-32 ~]# cat /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
default-character-set=utf8
max_allowed_packet = 1M		#add this line

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

[client]
default-character-set=utf8
```

##### 编译安装python不能退格和上下键
`
yum install readline-devel.x86_64
`
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
##### find content in file add replace
```
sed 's/42.62.52.40/202.206.192.137/g' file
sed -i 's/42.62.52.40/202.206.192.137/g' file
```
##### vi replace
```
%s/42.62.77.189:3000/202.206.192.134:8000/g
```

##### fonts
```
mkfontscale
mkfontdir
fc-cache
```

##### redis
```
redis-cli
flushdb
flushall
```

##### stop redis server

`redis-cli -p 6379 shutdown`

##### mysql replace
```
update serial set file_path = replace(file_path,'/home/','/data3/') where file_path like '/home/store/%';
```

##### mysql grant
```
mysql -uroot -proot -e "grant all privileges on bugs.* to bugs@localhost identified by 'root'"
```
##### useful commad
```
top htop vmstat ps pstree pmap iostat
```
##### git install
```
yum install libcurl-devel
./configure --prefix=/usr/local --with-curl --with-expat
make
make install
```

##### rsync
```
rsync -avzP reposes/ '-e ssh -p 60019' root@111.198.38.123:/data/yinzd
```
