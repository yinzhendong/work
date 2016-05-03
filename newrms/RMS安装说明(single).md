## RMS安装说明(single)
### 文档修订记录
```
----------------------------------------------------------------------------
Version		0.01
Date		2016-04-28
Author		Trent
Comment		创建文档
----------------------------------------------------------------------------
```

### 一. 概述
```
本说明书基于新RMS产品安装说明
系统安装包含前后台程序、接口服务、数据服务、CDN服务、转码服务等部分
建议各服务分服务器安装
操作系统均采用CentOS 6.x 64位操作系统
本说明安装环境为CentOS 6.7 x64
本说明是将所有服务装在一台服务器的安装说明
安装包本例路径为:/root/NewRMSInstallation
```

### 二. 全局设置
```
// 服务器添加更新源安装依赖包
rpm -ivh http://apt.sw.be/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm -ivh http://mirrors.ustc.edu.cn/epel//6/x86_64/epel-release-6-8.noarch.rpm
yum groupinstall -y "Development Tools"
yum install -y zlib zlib-devel readline readline-devel openssl openssl-devel mysql-devel lrzsz
```
### 三. 关闭SeLinux
```
vi /etc/selinux/config
----------------------------------------------------------------------------
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled                //将SELINUX=enforcing改为SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
----------------------------------------------------------------------------
```
### 四. 安装MySQL
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
### 五. 安装tomcat
```
//安装路径以/home/boful为例
mkdir -p /home/boful/web
tar -zxf /root/NewRMSInstallation/apache-tomcat-7.0.64.tar.gz -C /home/boful/
ln -s /home/boful/apache-tomcat-7.0.64/ /home/boful/tomcat

//修改tomcat配置文件
vi server.xml
----------------------------------------------------------------------------
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" URIEncoding="UTF8" />        //增加utf8编码，防止页面乱码

<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" URIEncoding="UTF-8" />        //增加utf8编码，防止页面乱码

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
        <Context path="/bcms" docBase="/home/boful/web/bcms" reloadable="true" />  //增加后台访问地址
        <Context path="" docBase="/home/boful/web/rms" reloadable="true" />        //增加前台访问地址
</Host>
```
### 六. 解压配置前端前台程序
```
// 解压前台程序到/home/boful/web/rms(对应tomcat中的context路径,如何打包参照xxx)
unzip -q rms-2016-04-28-12-09-44.heuet.6498.war -d /home/boful/web/rms

// 创建rms数据库
mysql -uroot -proot -e "create database rms default character set utf8"

// 修改rms配置文件
vi ~/.boful/rms/rms-config.properties
----------------------------------------------------------------------------
dataSource.pooled=true
dataSource.driverClassName=com.mysql.jdbc.Driver
dataSource.url=jdbc:mysql://192.168.1.229:3306/rms?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false
dataSource.dbCreate=update
dataSource.username=root
dataSource.password=root
hibernate.show_sql=true
#interfaceUrl=http://202.206.192.134:8000/
interfaceUrl=http://210.31.141.21:3000/
#服务器地址
localhostUrl=http://210.31.141.21:80/
#interfaceUrl=http://192.168.1.51:8000/
----------------------------------------------------------------------------

// 拷贝配置文件到rms
cp  ~/.boful/rms/rms-config.properties /home/boful/web/rms/WEB-INF/classes/
```

### 七. 解压配置前端后台程序
```
// 解压后台程序到/home/boful/web/bcms(对应tomcat中的context路径,如何打包参照xxx)
unzip -q bcms.126.war -d /home/boful/web/bcms

// 修改bcms配置文件
vi web/bcms/WEB-INF/classes/conn.properties

// 测试安装环境配置文件如下:
----------------------------------------------------------------------------
# httpclient conf
# server conf
# server to connect
# api service port
api_server=http://210.31.141.20
#api_server=http://192.168.1.51
api_port=8000
#api_port=8000
api_url=
#api_url=api

# statistical_url
#statistical_url=http://192.168.1.51/
statistical_url=http://210.31.141.21/
#statistical_url=http://42.62.77.189/api/


#login
login_url=login
#user info
user_info=user


# max total connections
max_conn_count=200
max_conn_per_route=20

max_conn_for_target_server=60
conn_idle_sec=60
defualt_conn_keep_alive=15
target_server_conn_keep_alive=45
----------------------------------------------------------------------------
```

### 八. 解压配置转码API服务程序
```
// 解压转码API程序到/home/boful/tomcat/webapps
unzip -q /root/NewRMSInstallation/ApiService.war -d /home/boful/tomcat/webapps/ApiService

// 修改转码API服务配置文件
vi /home/boful/tomcat/webapps/ApiService/WEB-INF/classes/apiConfig.properties

// 测试安装环境配置文件如下:
----------------------------------------------------------------------------
callback.onStartTranscode.uri=http://192.168.1.31:8000/transcode/callback
callback.onSubmitFail.uri=http://192.168.1.31:8000/transcode/callback
callback.onSubmitSuccess.uri=http://192.168.1.31:8000/transcode/callback
callback.onTranscode.uri=http://192.168.1.31:8000/transcode/callback
callback.onTranscodeFail.uri=http://192.168.1.31:8000/transcode/callback
callback.onTranscodeSuccess.uri=http://192.168.1.31:8000/transcode/callback
callback.SendProgress.uri=http://192.168.1.31:8000/transcode/callback

callback.onSendSysInfo.uri=http://192.168.1.31:8000/transcode/callback1
callback.onSendSysIP.uri=http://192.168.1.31:8000/transcode/callback2
callback.onSendQueueInfo.uri=http://192.168.1.31:8000/transcode/CallbackSystemInfo

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
```

### 九. 安装nginx
```
nginx负责对前端前台/前端后台的proxy转发;以及支持cdn服务的视频点播/视频下载/海报图片
的下载,本说明采用yum安装方式
```

```
// 卸载Apache httpd
yum remove httpd* -y

// 安装nginx
rpm -ivh http://nginx.org/packages/rhel/6/noarch/RPMS/nginx-release-rhel-6-0.el6.ngx.noarch.rpm
yum install nginx -y
chkconfig nginx on

// 配置nginx proxy到tomcat和cdn服务
vi /etc/nginx/conf.d/default.conf
----------------------------------------------------------------------------
location / {
    proxy_pass http://127.0.0.1:8080;           // 访问/proxy到tomcat前台页面
    #root   /usr/local/www/heuet;
    #index  index.php index.html index.htm;
}

# proxy the bcms to tomat
location ^~ /bcms {                             // 访问bcms到tomcat后台页面
    proxy_pass   http://127.0.0.1:8080/bcms;
}

server {
    listen      8200;                           // soffice启动监听8100端口,此处改为8200,注意修改enzo接口配置文件
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
// 测试安装环境配置文件如下:

// 启动nginx
nginx
```
### 十. 安装enzo接口
```
// update git
yum install libcurl-devel -y
tar zxf /root/NewRMSInstallation/git-2.7.3.tar.gz
cd /root/NewRMSInstallation/git-2.7.3
./configure --prefix=/usr/local --with-curl --with-expat
make
make install
mv /usr/bin/git /usr/bin/git.bak
ln -s /usr/local/bin/git /usr/bin/git

// git pull enzo-develop from coding.net
cd /home/boful
git clone -b develop https://git.coding.net/iskey/enzo.git

// 创建flowjs连接
mkdir -p /data/flowjs
ln -s /data/flowjs /home/boful/enzo/flowjs

// 创建enzo数据库
mysql -uroot -proot -e "create database enzo default character set utf8"

// 添加数据服务器mysql远程访问
// mysql -uroot -proot
// grant select,insert,delete,update on enzo.* to enzo identified by "1234.asd"
mysql -uroot -proot -e "grant select,insert,delete,update on enzo.* to enzo@'localhost' identified by \"1234.asd\""

// install mediainfo pip virtualenv
yum install -y mediainfo python-pip
pip install virtualenv

// install python2.7.8
tar -zxf /root/NewRMSInstallation/Python-2.7.8.tgz -C /root/NewRMSInstallation/
cd /root/NewRMSInstallation/Python-2.7.8
./configure --prefix=/usr/local/workspace/python2.7.8
make && make install

// virtualenv 指定python版本
virtualenv --python=/usr/local/workspace/python2.7.8/bin/python2.7 /home/boful/enzo/venv

// redis
tar -zxf /root/NewRMSInstallation/redis-2.4.10.tar.gz -C /root/NewRMSInstallation/
cd /root/NewRMSInstallation/redis-2.4.10
make install

// 启动redis服务
redis-server

// 初始化接口
cd /home/boful/enzo/
source venv/bin/activate
pip install Django==1.8.2 django-annoying==0.8.2 django-debug-toolbar==1.3.2 django-mptt==0.7.1 django-extensions==1.5.5 ipython==2.1.0 MySQL-python==1.2.5 pip==1.5.6 arrow==0.5.4 redis==2.10.3 django-redis-cache==0.13.0 hiredis==0.1.5 requests==2.7.0 django-filter==0.11.0 psutil==3.2.2 elasticsearch==2.1.0 django-cors-headers==1.1.0
make deps
python manage.py makemigrations enzo && python manage.py migrate
python manage.py init

// 修改接口配置文件中各服务IP和Port
vi /home/boful/enzo/enzo/settings.py
----------------------------------------------------------------------------
WEB_SERVER_IP = "192.168.1.31"
WEB_SERVER_ADDR = WEB_SERVER_IP
WEB_SERVER_PORT = "8000"

DATA_SERVER_ADDR = "192.168.1.31"
# 默认 CDN 和`数据服务器`上文件存储的路径同 web server 上一致，后续如果需要可自行修改
SHORT_FILE_PATH_IN_CDN = "cdn/"
SHORT_UPLOAD_FILE_PATH_IN_WEB_SERVER = "upload/"
SHORT_UPLOAD_FILE_PATH_IN_DATA_SERVER = "/upload/"
SHORT_TRANSCODE_FILE_PATH_IN_DATA_SERVER = "/encode/"
UPLOAD_FILE_PATH_IN_DATA_SERVER = "/data/transcode/upload/"
TRANSCODE_FILE_PATH_IN_DATA_SERVER = "/data/transcode/encode/"

CDN_ADDR_SET = ("192.168.1.31",)
DOWNLOAD_PORT = 8200
VIDEO_BROADCAST_ADDR = "rtmp://%s:1935/enzo/mp4" % CDN_ADDR_SET[0]
TEXT_BROADCAST_ADDR = "http://%s:%s/broadcast/" % (CDN_ADDR_SET[0],DOWNLOAD_PORT)
PIC_BROADCAST_ADDR = TEXT_BROADCAST_ADDR
DOWNLOAD_ADDR = "http://%s:%s/download/" % (CDN_ADDR_SET[0],DOWNLOAD_PORT)
DOWNLOAD_SUB_ADDR_FOR_FILE = "file"

TRANSCODE_SERVER_IP = "192.168.1.31"
TRANSCODE_SERVER_PORT = "8080"
TRANSCODE_SERVER_ADDR = "http://" + TRANSCODE_SERVER_IP + ":" + TRANSCODE_SERVER_PORT

LOG_SERVER_IP = "192.168.1.31"
----------------------------------------------------------------------------

// 启动接口服务
source /home/boful/enzo/venv/bin/activate
cd /home/boful/enzo/
python manage.py runserver 192.168.1.31:8000

// 配置rsync服务并启动
cp /home/boful/enzo/conf/enzo_rsyncd.conf /etc/rsyncd.conf
vi /etc/rsyncd.conf
----------------------------------------------------------------------------
[upload]
path = /home/boful/enzo/flowjs/            // 修改为实际路径
read only = no
uid = root
gid = root
hosts allow = 192.168.1.31                 // 修改为数据服务IP

[cdn]
path = /data/cdn/
read only = no
uid = root
gid = root
hosts allow = 192.168.1.31                 // 添加数据服务器IP
----------------------------------------------------------------------------
/usr/bin/rsync --daemon

// 配置logstash
tar -zxf /root/NewRMSInstallation/logstash-1.5.4.tar.gz -C /home/boful
vi /home/boful/enzo/conf/enzo_logstash
----------------------------------------------------------------------------
input {
    file {
        path => "/home/boful/enzo/dated_log/enzo_log"
        #exclude => "*.log"
        start_position => "beginning"
        type => "enzo"
    }
    file {
        path => "/usr/local/WowzaStreamingEngine/logs/wowzastreamingengine_access.log"
        #exclude => "*.log"
        start_position => "beginning"
        type => "wowza"
    }
    file {
        path => "/var/log/nginx/access.log"
        #exclude => "*.log"
        start_position => "beginning"
        type => "nginx"
    }
}
output {
    if "_grokparsefailure" not in [tags]{
        if [type] == "enzo" {
            stdout {
                codec => rubydebug
            }
            elasticsearch {
                index => "enzo-%{+YYYY.MM}"
                host => "192.168.1.31"
            }
        }
        if [type] == "wowza" {
            if [x-event] in ["play", "pause", "stop", "destroy", "disconnect", "create", "seek"] {
                stdout {
                    codec => rubydebug
                }
                elasticsearch {
                    index => "wowza-%{+YYYY.MM}"
                    host => "192.168.1.31"
                }
            }
        }
        if [type] == "nginx" {
            if [sub_type] == "ngx-cdn" {
                stdout {
                    codec => rubydebug
                }
                elasticsearch {
                    index => "ngx-cdn-%{+YYYY.MM}"
                    host => "192.168.1.31"
                }
            }
            else if [sub_type] == "ngx-stream" {
                stdout {
                    codec => rubydebug
                }
                elasticsearch {
                    index => "ngx-stream-%{+YYYY.MM}"
                    host => "192.168.1.31"
                }
            }
        }
    }
}
----------------------------------------------------------------------------
// 启动logstash
/home/boful/logstash-1.5.4/bin/logstash -f /home/boful/enzo/conf/enzo_logstash
```

### 十一. 安装数据服务
```
// 修改配置文件local_settings.py中的HOST为Enzo接口服务IP
cp /home/boful/enzo/conf/data_local_settings.py /home/boful/enzo/enzo/local_settings.py
vi /home/boful/enzo/enzo/local_settings.py
----------------------------------------------------------------------------
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'enzo',
        'USER': 'enzo',
        'PASSWORD': '1234.asd',
        'HOST': '192.168.1.31',
    }
}
----------------------------------------------------------------------------

// 添加crontab计划任务
crontab /home/boful/enzo/conf/data_cron

// 修改crontab计划任务和执行路径
crontab -e
----------------------------------------------------------------------------
*/10 * * * * source /home/boful/enzo/venv/bin/activate && /home/boful/enzo/venv/bin/python /home/boful/enzo/enzo/scripts/copy-file-from-web-server.py
*/10 * * * * source /home/boful/enzo/venv/bin/activate && /home/boful/enzo/venv/bin/python /home/boful/enzo/enzo/scripts/transcoding-file.py
*/30 * * * * source /home/boful/enzo/venv/bin/activate && /home/boful/enzo/venv/bin/python /home/boful/enzo/enzo/scripts/deliver-file-to-cdn.py
----------------------------------------------------------------------------

// 创建转码相关目录
mkdir -p /data/transcode/encode /data/transcode/upload

// 启动服务器管理程序
source /home/boful/enzo/venv/bin/activate
pip install web.py psutil
python /home/boful/enzo/enzo/scripts/web_stats.py 8120
```
### 十二. CDN服务
```
// wowza 注意记录输入的账号和密码，wowza管理页面需要登录
chmod +x /root/NewRMSInstallation/WowzaStreamingEngine-4.3.0-linux-x64-installer.run
cd /root/NewRMSInstallation/
./WowzaStreamingEngine-4.3.0-linux-x64-installer.run

// 配置wowza
登录http://192.168.1.31:8088，创建名为enzo的application，Content Directory配置为Application-specific directory

mkdir -p /data/cdn /data/cdn/poster /data/cdn/file
ln -s /data/cdn /usr/local/WowzaStreamingEngine/content/enzo
```
### 十三. 日志服务
```
tar -zxf /root/NewRMSInstallation/elasticsearch-1.7.2.tar.gz -C /home/boful/
/home/boful/elasticsearch-1.7.2/bin/elasticsearch -d
```
### 十四. 转码服务
```
// 安装转码环境
yum install -y ffmpeg mencoder mediainfo
unzip -q /root/NewRMSInstallation/app.zip -d /

// /下空间小,转码临时文件放在大磁盘空间
mv /app/temp/ /data/
ln -s /data/temp/ /app/temp

unzip -q /root/NewRMSInstallation/conv.zip -d /root/NewRMSInstallation
cd /root/NewRMSInstallation/conv
./install_openjdk.sh
./install_vncserver.sh
./install_swftools.sh
./install_openoffice.sh

// yum handbrakecli
wget http://pkgrepo.linuxtech.net/el6/release/linuxtech.repo -P /etc/yum.repos.d/
yum install -y handbrake-cli

// 字体文件
cd /app/fonts
mkfontscale
mkfontdir
fc-cache

// 拷贝文件到以下路径
cd /app
cp /app/libsigar-amd64-linux.so libsigar-x86-linux.so sigar.rar /usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin
cp /app/libsigar-amd64-linux.so libsigar-x86-linux.so sigar.rar /usr/lib/jvm/java-1.7.0-openjdk.x86_64/jre/bin
cp /app/libsigar-amd64-linux.so libsigar-x86-linux.so sigar.rar /usr/lib/jvm/java-1.7.0-openjdk.x86_64/lib
cp /app/libsigar-amd64-linux.so libsigar-x86-linux.so sigar.rar /usr/lib/jvm/java-1.7.0-openjdk.x86_64/jre/lib

// 修改java.policy
vi /usr/lib/jvm/java-1.7.0-openjdk.x86_64/jre/lib/security/java.policy
----------------------------------------------------------------------------
// permission for standard RMI registry port
permission java.net.SocketPermission "localhost:1099", "listen";

permission java.security.AllPermission;                                     // 增加
permission java.net.SocketPermission "*:*", "accept, connect, resolve";     // 增加

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
    <transcodeexe>HandBrakeCLI</transcodeexe>
</root>
----------------------------------------------------------------------------
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
### 十五. 防火墙配置
```
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
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8200 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8000 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8088 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 1935 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
----------------------------------------------------------------------------
```
### 十六. 服务放入后台方法
```
nohup command &
```

###  十七. 程序打包方法
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
grails war
mvn clean package
```

### 十八. 针对天科大实施的特殊说明
```
1. 天科大二期九所学校配置的是Dell的存储服务器主要配置如下:
    CPU:Intel(R) Xeon(R) CPU E5-2650 v2 @ 2.60GHz x2
    内存:64GB
    硬盘:200G固态硬盘x2,RAID0/3Tx12 RAID5,机械硬盘用于存储
    我安装的那台默认没有系统,默认可以看到以上信息
    我直接在固态上安装系统,将所有硬盘lvm划分为一个空间(肖老师觉得效率低,12块硬盘建议分成两组做RAID5,再和为一个分区用)
    需要注意的是:mkfs.ext4格式化硬盘最大只能到16T,大于16T请用mke2fs
    https://github.com/yinzhendong/work/blob/master/mke2fs.md
2. 可以用初始化数据库,初始系统环境,enzo接口会有修改,实际安装完成后需要比对一下数据;enzo数据库在189服务器
3. 安装完成后需要使用最新的rms/bcms程序
4. 安装mooc程序,只需创建mooc数据库/添加context/修改配置文件/nginx增加mooc的proxy
```
