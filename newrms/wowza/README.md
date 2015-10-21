#### Wowza

##### install wowza
```
chmod a+x WowzaStreamingEngine-4.3.0-linux-x64-installer.run
./WowzaStreamingEngine-4.3.0-linux-x64-installer.run
```

##### start wowza
```
/etc/init.d/WowzaStreamingEngine start
```

##### visit wowza
```
http://ip:1935
```

##### Streaming test
```
http://ip:8088/enginemanager
```
##### firewall port
```
1935
8088
```
