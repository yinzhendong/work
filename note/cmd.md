#### Linux Command

##### exact bz2 xz file
```
bzip2 -d **.tar.bz2
xz -d **.tar.xz
```

##### yum localinstall
```
yum localinstall mysql57-community-release-el6-7.noarch.rpm
```
##### find
`find ./Discory\ Channel/ -exec convmv -f GBK -t UTF-8 --notest ./* {} \;`

##### seq
`seq -f dir%3g | xargs mkdir`
`seq -s ":" 1 9`
`mkdir {1..9}`
