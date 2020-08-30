####### TASK 1

Мой сервер MySQL запущен в инстансе Ubuntu на Google Cloud Platform.
В терминале с помощью ssh подключился к инстансу и создал в домашней папке /home/asogoyan файл .my.cnf и вставил туда

[client]
user=root
password='мой пароль'

Теперь по команде mysql в терминале получаю:

  asogoyan@arsen:~$ mysql
  Welcome to the MySQL monitor.  Commands end with ; or \g.
  Your MySQL connection id is 30
  Server version: 8.0.21-0ubuntu0.20.04.4 (Ubuntu)

  Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

  Oracle is a registered trademark of Oracle Corporation and/or its
  affiliates. Other names may be trademarks of their respective
  owners.

  Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

  mysql>


####### TASK 2

mysql> create database example;
Query OK, 1 row affected (0.01 sec)

mysql> use example;
Database changed
mysql> create table users (id int unsigned, name varchar(255));
Query OK, 0 rows affected (0.06 sec)

mysql> describe users;
+-------+--------------+------+-----+---------+-------+
| Field | Type         | Null | Key | Default | Extra |
+-------+--------------+------+-----+---------+-------+
| id    | int unsigned | YES  |     | NULL    |       |
| name  | varchar(255) | YES  |     | NULL    |       |
+-------+--------------+------+-----+---------+-------+
2 rows in set (0.02 sec)



####### TASK 3

asogoyan@arsen:~$ mysqldump example > example.sql
asogoyan@arsen:~$ mysql

mysql> create database sample;
Query OK, 1 row affected (0.01 sec)

mysql> \q
Bye

asogoyan@arsen:~$ mysql sample < example.sql
asogoyan@arsen:~$ mysql


mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| example            |
| information_schema |
| mysql              |
| performance_schema |
| sample             |
| sys                |
+--------------------+
6 rows in set (0.00 sec)


mysql> use sample;

mysql> show tables;
+------------------+
| Tables_in_sample |
+------------------+
| users            |
+------------------+
1 row in set (0.00 sec)

mysql> describe users;
+-------+--------------+------+-----+---------+-------+
| Field | Type         | Null | Key | Default | Extra |
+-------+--------------+------+-----+---------+-------+
| id    | int unsigned | YES  |     | NULL    |       |
| name  | varchar(255) | YES  |     | NULL    |       |
+-------+--------------+------+-----+---------+-------+
2 rows in set (0.00 sec)




####### TASK 4

asogoyan@arsen:~$ mysqldump mysql help_keyword --where '1 limit 100' > help_keyword.sql




