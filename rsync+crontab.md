## rsync+crontab
```
Date:2016-06-21
```
##### description
```
use rsync add crontab to make backup
from A to B
ssh-keygen on A
then copy A id_rsa.pub to B
and id_rsa.pub in authorized_keys on B
and rsync to crontab
```

##### command
```
ssh-keygen
cat id_rsa.pub >> /root/.ssh/authorized_keys
*/1 * * * * rsync -avP /root/tools/ root@192.168.1.40:/root/tools/
*/1 * * * * rsync -avP /root/repos/ root@192.168.1.40:/root/repos/

```
