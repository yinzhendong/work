#### Git Skills

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

#### tomcat session timeout

`vi modify web.xml`
```
<session-config>
        <session-timeout>30</session-timeout>
</session-config>
```

#### mysql grant
```
grant all on *.* to root@'%' identified by 'password' with grant option;
flush privileges;
```
#### mysql max_allowed_packet
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
