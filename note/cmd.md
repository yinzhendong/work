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
