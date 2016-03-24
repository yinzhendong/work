##RMS安装说明

###文档修订记录
```
----------------------------------------------------------------------------
Version		0.01
Date		2016-03-11
Author		Trent
Comment		创建文档
----------------------------------------------------------------------------
```

###概述
```
本说明书基于新RMS产品安装说明
系统安装包含前后台程序、接口服务、数据服务、CDN服务、转码服务等部分
建议各服务分服务器安装
操作系统均采用CentOS 6.x 64位操作系统
本说明安装环境为CentOS 6.7 x64
```

###全局设置
```
// 服务器添加更新源安装依赖包
rpm -ivh http://apt.sw.be/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm -ivh http://mirrors.ustc.edu.cn/epel//6/x86_64/epel-release-6-8.noarch.rpm
yum groupinstall -y "Development Tools"
yum install -y zlib zlib-devel readline readline-devel openssl openssl-devel mysql-devel lrzsz
```
###web程序
####1. remove httpd
```
yum remove httpd*
```
####2. install Nginx
```
rpm -ivh http://nginx.org/packages/rhel/6/noarch/RPMS/nginx-release-rhel-6-0.el6.ngx.noarch.rpm
yum install nginx -y
chkconfig nginx on

// 配置nginx proxy tomcat
vi /etc/nginx/conf.d/default.conf
----------------------------------------------------------------------------
location / {
    proxy_pass http://127.0.0.1:8080;			// 访问/proxy到tomcat前台页面
    #root   /usr/local/www/heuet;
    #index  index.php index.html index.htm;
}

# proxy the bcms to tomat
location ^~ /bcms {								// 访问bcms到tomcat后台页面
    proxy_pass   http://127.0.0.1:8080/bcms;
}
----------------------------------------------------------------------------
// 启动nginx
nginx
```
####3. config selinux
```
vi /etc/selinux/config
----------------------------------------------------------------------------
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled				//将SELINUX=enforcing改为SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
----------------------------------------------------------------------------
```
####4. install mysql
```
yum install mysql mysql-server mysql-devel -y
chkconfig mysqld on

vi /etc/my.cnf
----------------------------------------------------------------------------
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

default-character-set=utf8  //增加

[client]                    //增加
default-character-set=utf8  //增加

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
----------------------------------------------------------------------------
/etc/init.d/mysqld start
mysqladmin -u root password "root"
```
####5. install tomcat & unzip war
```
//安装路径以/usr/local/workspace为例
tar -zxvf apache-tomcat-7.0.64.tar.gz -C /usr/local/workspace/
ln -s /usr/local/workspace/apache-tomcat-7.0.64/ /usr/local/workspace/tomcat

//修改tomcat配置文件
vi server.xml
----------------------------------------------------------------------------
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" URIEncoding="UTF8" />		//增加utf8编码，防止页面乱码

<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" URIEncoding="UTF-8" />		//增加utf8编码，防止页面乱码

<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">

        <!-- SingleSignOn valve, share authentication between web applications
             Documentation at: /docs/config/valve.html -->
        <!--
        <Valve className="org.apache.catalina.authenticator.SingleSignOn" />
        -->

        <!-- Access log processes all example.
             Documentation at: /docs/config/valve.html
             Note: The pattern used is equivalent to using pattern="common" -->
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />
        <Context path="/bcms" docBase="/usr/local/workspace/web/bcms" reloadable="true" />	//增加后台访问地址
        <Context path="" docBase="/usr/local/workspace/web/rms" reloadable="true" />		//增加前台访问地址
</Host>
----------------------------------------------------------------------------

//解压war包到/usr/local/workspace/web
mkdir -p /usr/local/workspace/web/bcms /usr/local/workspace/web/rms
unzip bcms.war -d /usr/local/workspace/web/bcms
unzip rms-2016-03-11-22-13-07.war -d /usr/local/workspace/web/rms

//启动tomcat，可以用tomcat.sh脚本
./tomcat.sh start|stop|restart|printlog

//创建前台数据库
mysql> create database rms default character set utf8;

//修改前台配置文件
vi ~/.boful/rms/rms-config.properties
----------------------------------------------------------------------------
##############MYSQL配置################################
dataSource.pooled=true
dataSource.driverClassName=com.mysql.jdbc.Driver
dataSource.url=jdbc:mysql://localhost:3306/rms?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false			//修改数据库连接
#dataSource.url=jdbc:mysql://boful.3322.org:21/ntstsinghua?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false
dataSource.dbCreate=update
dataSource.username=root		//数据库用户
#dataSource.password=root
dataSource.password=root		//数据库密码
hibernate.show_sql=true
interfaceUrl=http://192.168.1.51:8000/ 		//接口地址
#河北经贸统一身份认证秘钥
zfKey=zfsoft_heuet_87656563
----------------------------------------------------------------------------

// 修改后台配置文件conn.properties
vi /usr/local/workspace/web/bcms/WEB-INF/classes/conn.properties
----------------------------------------------------------------------------
# httpclient conf
# server conf
# server to connect
# api service port
api_server=http://192.168.1.51			// 修改为实际接口IP地址
api_port=8000							// 修改为实际接口端口
#api_port=80
api_url=
#api_url=api

# statistical_url
statistical_url=http://192.168.1.51/		// 修改为实际地址
#statistical_url=http://42.62.77.189/api/
----------------------------------------------------------------------------

// 修改后台上传地址
vi /usr/local/workspace/web/bcms/resources/resourcemgr/resourceManager.js
----------------------------------------------------------------------------
/**
 * 1、高级查询
 * 2、文件上传
 * 3、资源（子）选择
 * 4、元数据编辑
 * 5、增、删、改、预览
 * */
var file_url = "http://192.168.1.51:8000";			// 修改为接口地址
----------------------------------------------------------------------------

// 配置防火墙添加80端口访问
vi /etc/sysconfig/iptables
----------------------------------------------------------------------------
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT		// 增加
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
----------------------------------------------------------------------------

// 重启防火墙
/etc/init.d/iptables restart

// service
tomcat nginx mysql
```

###接口服务
```
// mysql
参照前后台程序中的mysql安装，安装完成后创建接口数据库enzo
create database enzo default character set utf8;

// install mediainfo pip virtualenv
yum install -y mediainfo python-pip
pip install virtualenv

// python2.7.8
wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz
tar xf Python-2.7.8.tgz
cd Python-2.7.8
./configure --prefix=/usr/local/workspace/python2.7.8
make && make install

// virtualenv 指定python版本
virtualenv --python=/usr/local/workspace/python2.7.8/bin/python2.7 /usr/local/workspace/enzo/venv

// redis
tar -zxvf redis-2.4.10.tar.gz -C /usr/local/workspace/
cd /usr/local/workspace/redis-2.4.10
make install
redis-server

// 初始化接口
cd /usr/local/workspace/enzo
mkdir -p /usr/local/workspace/enzo/dated_log/
source venv/bin/activate
pip install Django==1.8.2 django-annoying==0.8.2 django-debug-toolbar==1.3.2 django-mptt==0.7.1 \
django-extensions==1.5.5 ipython==2.1.0 MySQL-python==1.2.5 pip==1.5.6
make deps
python manage.py makemigrations enzo && python manage.py migrate
python manage.py init

// 修改接口配置文件中各服务IP和Port
vi /usr/local/workspace/enzo/enzo/settings.py
----------------------------------------------------------------------------
WEB_SERVER_IP = "192.168.1.51"
WEB_SERVER_ADDR = WEB_SERVER_IP
WEB_SERVER_PORT = "8000"

DATA_SERVER_ADDR = "192.168.1.52"
# 默认 CDN 和`数据服务器`上文件存储的路径同 web server 上一致，后续如果需要可自行修改
SHORT_FILE_PATH_IN_CDN = "cdn/"
SHORT_UPLOAD_FILE_PATH_IN_WEB_SERVER = "upload/"
SHORT_UPLOAD_FILE_PATH_IN_DATA_SERVER = "/upload/"
SHORT_TRANSCODE_FILE_PATH_IN_DATA_SERVER = "/encode/"
UPLOAD_FILE_PATH_IN_DATA_SERVER = "/data/transcode/upload/"
TRANSCODE_FILE_PATH_IN_DATA_SERVER = "/data/transcode/encode/"

CDN_ADDR_SET = ("192.168.1.53",)
DOWNLOAD_PORT = 8100
VIDEO_BROADCAST_ADDR = "rtmp://%s:1935/enzo/mp4" % CDN_ADDR_SET[0]
TEXT_BROADCAST_ADDR = "http://%s:%s/broadcast/" % (CDN_ADDR_SET[0],DOWNLOAD_PORT)
PIC_BROADCAST_ADDR = TEXT_BROADCAST_ADDR
DOWNLOAD_ADDR = "http://%s:%s/download/" % (CDN_ADDR_SET[0],DOWNLOAD_PORT)
DOWNLOAD_SUB_ADDR_FOR_FILE = "file"

TRANSCODE_SERVER_IP = "192.168.1.55"
TRANSCODE_SERVER_PORT = "8080"
TRANSCODE_SERVER_ADDR = "http://" + TRANSCODE_SERVER_IP + ":" + TRANSCODE_SERVER_PORT

LOG_SERVER_IP = "192.168.1.54"
----------------------------------------------------------------------------

// 启动接口服务
source /usr/local/workspace/enzo/venv/bin/activate
cd /usr/local/workspace/enzo/
python manage.py runserver 192.168.1.51:8000

// 配置防火墙添加8000端口访问
vi /etc/sysconfig/iptables
----------------------------------------------------------------------------
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8000 -j ACCEPT		// 增加
-A INPUT -m state --state NEW -m tcp -p tcp --dport 873 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
----------------------------------------------------------------------------

// 重启防火墙
/etc/init.d/iptables restart

// 添加数据服务器mysql远程访问
grant select,insert,delete,update on enzo.* to enzo identified by "1234.asd"

// 配置rsync服务
cp /usr/local/workspace/enzo/conf/enzo_rsyncd.conf /etc/rsyncd.conf
/usr/bin/rsync --daemon
vi /etc/rsyncd.conf
----------------------------------------------------------------------------
[upload]
path = /usr/local/workspace/enzo/flowjs/			// 修改为实际路径
read only = no
uid = root
gid = root
hosts allow = 192.168.1.52							// 修改为数据服务IP
----------------------------------------------------------------------------

// 配置logstash
tar -zxvf logstash-1.5.4.tar.gz -C /usr/local/workspace
/usr/local/workspace/logstash-1.5.4/bin/logstash -f /usr/local/workspace/enzo/conf/enzo_logstash

// 需要启动的服务
redis
enzo
logstash
```

###数据服务
```
// install pip virtualenv
yum install -y python-pip
pip install virtualenv

// python2.7.8
wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz
tar xf Python-2.7.8.tgz -C /usr/local/workspace/
cd /usr/local/workspace/Python-2.7.8
./configure --prefix=/usr/local/workspace/python2.7.8
make && make install

// virtualenv 指定python版本
virtualenv --python=/usr/local/workspace/python2.7.8/bin/python2.7 /usr/local/workspace/enzo/venv

cd /usr/local/workspace/enzo
source venv/bin/activate
pip install Django==1.8.2 django-annoying==0.8.2 django-debug-toolbar==1.3.2 django-mptt==0.7.1 \
django-extensions==1.5.5 ipython==2.1.0 MySQL-python==1.2.5 pip==1.5.6
make deps

// 修改配置文件local_settings.py中的HOST为Enzo接口服务IP
cp /usr/local/workspace/enzo/conf/data_local_settings.py /usr/local/workspace/enzo/enzo/local_settings.py
vi /usr/local/workspace/enzo/enzo/local_settings.py
----------------------------------------------------------------------------
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'enzo',
        'USER': 'enzo',
        'PASSWORD': '1234.asd',
        'HOST': '192.168.1.51',
    }
}
----------------------------------------------------------------------------

// 添加crontab计划任务
crontab /usr/local/workspace/enzo/conf/data_cron

// 修改crontab计划任务和执行路径
crontab -e
----------------------------------------------------------------------------
*/10 * * * * source /usr/local/workspace/enzo/venv/bin/activate && /usr/local/workspace/enzo/venv/bin/python /usr/local/workspace/enzo/enzo/scripts/copy-file-from-web-server.py
*/10 * * * * source /usr/local/workspace/enzo/venv/bin/activate && /usr/local/workspace/enzo/venv/bin/python /usr/local/workspace/enzo/enzo/scripts/transcoding-file.py
*/30 * * * * source /usr/local/workspace/enzo/venv/bin/activate && /usr/local/workspace/enzo/venv/bin/python /usr/local/workspace/enzo/enzo/scripts/deliver-file-to-cdn.py
----------------------------------------------------------------------------

// 创建转码相关目录
mkdir -p /data/transcode/encode /data/transcode/upload

// 安装mediainfo
yum install mediainfo -y

// 服务器管理程序
source /usr/local/workspace/enzo/venv/bin/activate
pip install web.py psutil
python /usr/local/workspace/enzo/enzo/scripts/web_stats.py 8120

// service
web_stats.py
```

###CDN服务
```
// nginx安装
rpm -ivh http://nginx.org/packages/rhel/6/noarch/RPMS/nginx-release-rhel-6-0.el6.ngx.noarch.rpm
yum install nginx -y
chkconfig nginx on

// 配置nginx，增加如下内容
vi /etc/nginx/conf.d/default.conf
----------------------------------------------------------------------------
server {
    listen      8100;
    server_name localhost;

    root /data/cdn;

    location / {
    }

    location /download {
        rewrite ^/download/(.*) /$1? permanent;
    }
    location /broadcast {
        rewrite ^/broadcast/(.*) /$1? permanent;
    }
}
----------------------------------------------------------------------------
// 启动nginx
nginx

// 配置防火墙添加8100端口访问
vi /etc/sysconfig/iptables
----------------------------------------------------------------------------
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8100 -j ACCEPT		// 增加
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8088 -j ACCEPT		// 增加 wowza management
-A INPUT -m state --state NEW -m tcp -p tcp --dport 1935 -j ACCEPT		// 增加 wowza media service
-A INPUT -m state --state NEW -m tcp -p tcp --dport 873 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
----------------------------------------------------------------------------

// 重启防火墙
/etc/init.d/iptables restart

// wowza 注意记录输入的账号和密码，wowza管理页面需要登录
mkdir -p /usr/local/workspace
chmod +x WowzaStreamingEngine-4.3.0-linux-x64-installer.run
./WowzaStreamingEngine-4.3.0-linux-x64-installer.run

// 配置wowza
登录http://192.168.1.53:8088，创建名为enzo的application，Content Directory配置为Application-specific directory

mkdir -p /data/cdn /data/cdn/poster /data/cdn/file
ln -s /data/cdn /usr/local/WowzaStreamingEngine/content/enzo

cp /usr/local/workspace/enzo/conf/cdn_rsyncd.conf /etc/rsyncd.conf
vi /etc/rsyncd.conf
----------------------------------------------------------------------------
[cdn]
path = /data/cdn/
read only = no
uid = root
gid = root
hosts allow = 192.168.1.52		// 添加数据服务器IP
----------------------------------------------------------------------------
/usr/bin/rsync --daemon

// 配置logstash
tar -zxvf logstash-1.5.4.tar.gz -C /usr/local/workspace
/usr/local/workspace/logstash-1.5.4/bin/logstash -f /usr/local/workspace/enzo/conf/cdn_logstash

// install pip virtualenv
yum install -y python-pip
pip install virtualenv

// python2.7.8
wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz
tar xf Python-2.7.8.tgz -C /usr/local/workspace/
cd /usr/local/workspace/Python-2.7.8
./configure --prefix=/usr/local/workspace/python2.7.8
make && make install

// virtualenv 指定python版本
virtualenv --python=/usr/local/workspace/python2.7.8/bin/python2.7 /usr/local/workspace/enzo/venv

cd /usr/local/workspace/enzo
source venv/bin/activate
pip install Django==1.8.2 django-annoying==0.8.2 django-debug-toolbar==1.3.2 django-mptt==0.7.1 \
django-extensions==1.5.5 ipython==2.1.0 MySQL-python==1.2.5 pip==1.5.6
make deps

// 服务器管理程序
source /usr/local/workspace/enzo/venv/bin/activate
pip install web.py psutil
python /usr/local/workspace/enzo/enzo/scripts/web_stats.py 8120

// service
nginx rsync web_stats.py
```

###日志服务
```
tar -zxf elasticsearch-1.7.2.tar.gz -C /usr/local/workspace/
/usr/local/workspace/elasticsearch-1.7.2/bin/elasticsearch
```

###转码服务
```
// 安装转码环境
yum install -y ffmpeg mediainfo mencoder
unzip app.zip -d /
unzip conv.zip -d /usr/local/workspace/
cd /usr/local/workspace/conv
./install_openjdk.sh
./install_vncserver.sh
./install_swftools.sh
./install_openoffice.sh
./install_handbrake.sh

// 安装ApiService，修改配置文件
tar -zxf /usr/local/workspace/conv/apache-tomcat-7.0.64.tar.gz -C /app
ln -s /app/apache-tomcat-7.0.64/ /app/tomcat
unzip /app/ApiService.war -d /app/tomcat/webapps/ApiService

vi /app/tomcat/webapps/ApiService/WEB-INF/classes/apiConfig.properties
----------------------------------------------------------------------------
callback.onStartTranscode.uri=http://192.168.1.51:8000/transcode/callback
callback.onSubmitFail.uri=http://192.168.1.51:8000/transcode/callback
callback.onSubmitSuccess.uri=http://192.168.1.51:8000/transcode/callback
callback.onTranscode.uri=http://192.168.1.51:8000/transcode/callback
callback.onTranscodeFail.uri=http://192.168.1.51:8000/transcode/callback
callback.onTranscodeSuccess.uri=http://192.168.1.51:8000/transcode/callback
callback.SendProgress.uri=http://192.168.1.51:8000/transcode/callback

callback.onSendSysInfo.uri=http://192.168.1.51:8000/transcode/callback1
callback.onSendSysIP.uri=http://192.168.1.51:8000/transcode/callback2
callback.onSendQueueInfo.uri=http://192.168.1.51:8000/transcode/CallbackSystemInfo

#callback.onStartTranscode.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackTest
#callback.onSubmitFail.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackTest
#callback.onSubmitSuccess.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackTest
#callback.onTranscode.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackTest
#callback.onTranscodeFail.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackTest
#callback.onTranscodeSuccess.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackTest
#callback.SendProgress.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackTest
#CPU MEM
#callback.onSendSysInfo.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackSystemInfo
#IP
#callback.onSendSysIP.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackSystemInfo
#\u56de\u8c03QUEUE
#callback.onSendQueueInfo.uri=http://192.168.1.104/AjaxDemo001/api/ApiCallback/CallbackSystemInfo

#transSWF.connectString.uri=rmi://127.0.0.1:7771/ConverService
#transVoide.connectString.uri=rmi://127.0.0.1:7771/ConverService
transSWF.connectString.uri=rmi://127.0.0.1:7771/ConverService
transVoide.connectString.uri=rmi://127.0.0.1:7771/ConverService
transImage.connectString.uri=rmi://127.0.0.1:7771/ConverService


getsysinfo.connectString.uri=rmi://127.0.0.1:8881/Test
----------------------------------------------------------------------------

// 字体文件
cd /app/fonts
mkfontscale
mkfontdir
fc-cache

// 拷贝文件到以下路径
cd /app
cp libsigar-amd64-linux.so libsigar-x86-linux.so sigar.rar /usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin
cp libsigar-amd64-linux.so libsigar-x86-linux.so sigar.rar /usr/lib/jvm/java-1.7.0-openjdk.x86_64/jre/bin
cp libsigar-amd64-linux.so libsigar-x86-linux.so sigar.rar /usr/lib/jvm/java-1.7.0-openjdk.x86_64/lib
cp libsigar-amd64-linux.so libsigar-x86-linux.so sigar.rar /usr/lib/jvm/java-1.7.0-openjdk.x86_64/jre/lib

// 修改java.policy
vi /usr/lib/jvm/java-1.7.0-openjdk.x86_64/jre/lib/security/java.policy
----------------------------------------------------------------------------
// permission for standard RMI registry port
permission java.net.SocketPermission "localhost:1099", "listen";

permission java.security.AllPermission;										// 增加
permission java.net.SocketPermission "*:*", "accept, connect, resolve";		// 增加

// "standard" properies that can be read by anyone
----------------------------------------------------------------------------

// 修改zookeeper配置文件
vi /app/zookeeper/conf/zoo.cfg
----------------------------------------------------------------------------
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/app/zk/data
dataLogDir=/app/log/zk/datalog
# the port at which the clients will connect
clientPort=2181
#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
server.1=127.0.0.1:8881:8888
----------------------------------------------------------------------------

// 修改001配置文件
vi /app/output/001/config/SftpConfig.xml
----------------------------------------------------------------------------
<?xml version="1.0" encoding="utf-8"?>
<root>
    <host>192.168.1.52</host>
    <username>root</username>
    <password>password</password>
    <port>22</port>
    <temppath>/app/temp/</temppath>
    <tempConvertpath>/app/temp/encode/</tempConvertpath>
    <Convertpath>/app/temp/</Convertpath>
    <EncodeParam>-e x264</EncodeParam>
    <!--截图后图片存放在址-->
    <picpath>/app/temp/pic/</picpath>
    <tempPicConvertpath>/app/temp/pic/</tempPicConvertpath>
    <!--截图程式地址-->
    <picexe>/usr/bin/ffmpeg</picexe>
    <!--转AVI程式地址-->
    <aviexe>/usr/bin/mencoder</aviexe>
    <!--Mediainfo-->
    <mediainfo>/usr/bin/mediainfo</mediainfo>
    <outflag>true</outflag>
</root>
----------------------------------------------------------------------------

// 配置防火墙添加8080端口访问
vi /etc/sysconfig/iptables
----------------------------------------------------------------------------
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT		// 增加
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
----------------------------------------------------------------------------

// 重启防火墙
/etc/init.d/iptables restart

// 顺序启动转码服务
1. 启动soffice
nohup soffice -headless -accept="socket,host=127.0.0.1,port=8100;urp;" -nofirststartwizard &
2. 启动tomcat
/app/tomcat/bin/startup.sh
3. 启动zookeeper
/app/zookeeper/bin/zkServer.sh start
4. 启动001，转码服务
cd /app/output/001
nohup java -jar FileTransEncode.jar &
5. 启动002，转码负载
cd /app/output/002
nohup java -jar FileTransCache.jar > /dev/null 2>&1 &
```

###本地打包
```
//解压grails-2.4.5
unzip grails-2.4.5.zip

//添加环境变量
vi /etc/profile
----------------------------------------------------------------------------
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin

export GRAILS_HOME=/usr/local/workspace/grails-2.4.5
export PATH=$PATH:$GRAILS_HOME/bin
----------------------------------------------------------------------------
soruce /etc/profile

//打包
grais war

```

