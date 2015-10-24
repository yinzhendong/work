#### nginx

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


