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
