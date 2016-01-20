#### note

```
show VARIABLES like '%log%';
show VARIABLES like '%max_allowed_packet%';

SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;
show grants for 'root'@'%';

update user set password=password('password') where user='root';
flush privileges;
```
