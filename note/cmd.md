#### Linux Command

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
`more /etc/isssue`
```
[root@tmp workspace]# more /etc/issue
CentOS release 6.7 (Final)
Kernel \r on an \m
```
