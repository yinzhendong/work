#### KB

##### mysql max_allowed_packet

###### Problem description
```
2015-12-25 15:01:05,072 [ajp-apr-8009-exec-55] ERROR spi.SqlExceptionHelper  - Packet for query is too large (1471 > 1024). You can change this value on the server by setting the max_allowed_packet' variable.
2015-12-25 15:01:05,075 [ajp-apr-8009-exec-55] ERROR errors.GrailsExceptionResolver  - PacketTooBigException occurred when processing request: [GET] /bmc/admin/playVideo/ff80808150cc9c500150ccb595f40000
Packet for query is too large (1471 > 1024). You can change this value on the server by setting the max_allowed_packet' variable.. Stacktrace follows:
com.mysql.jdbc.PacketTooBigException: Packet for query is too large (1471 > 1024). You can change this value on the server by setting the max_allowed_packet' variable.
        at com.mysql.jdbc.MysqlIO.send(MysqlIO.java:3778)
        at com.mysql.jdbc.MysqlIO.sendCommand(MysqlIO.java:2471)
        at com.mysql.jdbc.MysqlIO.sqlQueryDirect(MysqlIO.java:2651)
        at com.mysql.jdbc.ConnectionImpl.execSQL(ConnectionImpl.java:2734)
        at com.mysql.jdbc.PreparedStatement.executeInternal(PreparedStatement.java:2155)
        at com.mysql.jdbc.PreparedStatement.executeQuery(PreparedStatement.java:2322)
        at com.mchange.v2.c3p0.impl.NewProxyPreparedStatement.executeQuery(NewProxyPreparedStatement.java:76)
        at org.grails.datastore.gorm.GormStaticApi$_methodMissing_closure2.doCall(GormStaticApi.groovy:102)
        at com.boful.bmc.admin.controllers.AdminController.playVideo(AdminController.groovy:307)
        at grails.plugin.cache.web.filter.PageFragmentCachingFilter.doFilter(PageFragmentCachingFilter.java:198)
        at grails.plugin.cache.web.filter.AbstractFilter.doFilter(AbstractFilter.java:63)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
        at java.lang.Thread.run(Thread.java:745)
```
###### Resolve
```
1. show VARIABLES like '%max_allowed_packet%';
2. my.cnf [mysqld] add
	 max_allowed_packet = 1M
```
