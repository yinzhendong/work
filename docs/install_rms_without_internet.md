## RMS无互联网访问安装

```
解决思路:
why: 安装RMS时需要访问外网用yum install安装依赖的包.
how: 用CentOS安装光盘建立本地的yum更新源,安装时直接从本地源进行安装和更新.
```

#### 1. 挂载iso文件
```
mkdir /mnt/{dvd1,dvd2}
mount -o loop /root/CentOS-6.5-x86_64-bin-DVD1.iso /mnt/dvd1
mount -o loop /root/CentOS-6.5-x86_64-bin-DVD2.iso /mnt/dvd2
```

#### 2. 备份原始repo，编辑本地更新源
```
cd /etc/yum.repos.d/
mkdir backup
mv *.repo ./backup/
vi local.repo
```
#### 3. local.repo内容如下
```
[local]
name=local
baseurl=file:///mnt/dvd1
        file:///mnt/dvd2
enabled=1
gpgcheck=0
```
#### 4. 更新yum源信息
```
yum clean all
yum makecache
```

#### 5. 进行RMS安装
   
