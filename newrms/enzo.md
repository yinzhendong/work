#enzo - 教育类内容管理系统

## 开发环境的依赖

1. MySQL
2. Python pip
3. Python virtualenv


## 搭建本地开发环境:

安装好上一步的依赖后，就可以在本地搭建开发环境了：

1 `git clone https://git.coding.net/kobras/enzo.git`

2 `cd enzo`

3 `make venv`

4 `source venv/bin/activate`

5 `make deps`

6 创建数据库：`mysql -uroot -p`, 并建立数据库：`create database enzo character set=utf8`，数据库名要跟上一步骤中配置的`NAME`一致
  根据设计好的 models 来创建数据库的表, `python manage.py makemigrations enzo && python manage.py migrate`

7 添加测试数据：`python manage.py init`
  对应的，会创建 3 个用户，分别是

  USERNAME	PASSWORD

  superadmin	superadmin

  admin1	admin1

  admin2	admin2

  admin3	admin3

  user1		user1

  user2		user2

  user3		user3

8 单元测试：make test

9 运行开发服务器：`python manage.py runserver`

10 根据 `docs` 中文档中定义的办法进行 API 访问