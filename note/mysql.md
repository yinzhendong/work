#### mysql

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
```
