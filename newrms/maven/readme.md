
```
tar zxvf apache-maven-3.3.3-bin.tar.gz
ln -s /root/apache-maven-3.3.3/bin/mvn /usr/bin/mvn

unzip bcms-master.zip
cd bcms-master
mvn compile
mvn war:war
```
// set enzo config
vi /root/bcms-master/src/main/java/brms/action/Proxy.java


