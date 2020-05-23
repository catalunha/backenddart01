
https://medium.com/flutter-comunidade-br/criando-uma-aplica%C3%A7%C3%A3o-web-com-dart-parte-1-aqueduct-b%C3%A1sico-conex%C3%A3o-com-banco-e-autentica%C3%A7%C3%A3o-jwt-bd3afad3ae1a

https://stackoverflow.com/questions/37694987/connecting-to-postgresql-in-a-docker-container-from-outside


https://www.youtube.com/watch?v=-OvfaZE1_5U

CREATE TABLE _ToDo(
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  done BOOLEAN
)

catalunha@stack:~/flutter-projects$ sudo docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres:9.6



catalunha@stack:~/flutter-projects$ docker exec -it ca2182f20c1a bash
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/containers/ca2182f20c1a/json: dial unix /var/run/docker.sock: connect: permission denied
catalunha@stack:~/flutter-projects$ sudo docker exec -it ca2182f20c1a bash
[sudo] password for catalunha: 
root@ca2182f20c1a:/# psql -U postgres
psql (9.6.18)
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=# CREATE TABLE _ToD(
postgres(#   id SERIAL PRIMARY KEY,
postgres(#   name VARCHAR,
postgres(#   done BOOLEAN
postgres(# )
postgres-# ;
CREATE TABLE
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=# \d
             List of relations
 Schema |    Name     |   Type   |  Owner   
--------+-------------+----------+----------
 public | _tod        | table    | postgres
 public | _tod_id_seq | sequence | postgres
(2 rows)

postgres=# \D
Invalid command \D. Try \? for help.
postgres=# CREATE TABLE _ToDo(
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  done BOOLEAN
)
;
CREATE TABLE
postgres=# \d+
                           List of relations
 Schema |     Name     |   Type   |  Owner   |    Size    | Description 
--------+--------------+----------+----------+------------+-------------
 public | _tod         | table    | postgres | 8192 bytes | 
 public | _tod_id_seq  | sequence | postgres | 8192 bytes | 
 public | _todo        | table    | postgres | 8192 bytes | 
 public | _todo_id_seq | sequence | postgres | 8192 bytes | 
(4 rows)

postgres=# insert into _todo(id,name,done) values(1,'a',true);
INSERT 0 1
postgres=# select * from _todo;
 id | name | done 
----+------+------
  1 | a    | t
(1 row)

postgres=# \d+ _todo
                                                  Table "public._todo"
 Column |       Type        |                     Modifiers                      | Storage  | Stats targe
t | Description 
--------+-------------------+----------------------------------------------------+----------+------------
--+-------------
 id     | integer           | not null default nextval('_todo_id_seq'::regclass) | plain    |            
  | 
 name   | character varying |                                                    | extended |            
  | 
 done   | boolean           |                                                    | plain    |            
  | 
Indexes:
    "_todo_pkey" PRIMARY KEY, btree (id)

postgres=# \d+ _todo
                                                  Table "public._todo"
 Column |       Type        |                     Modifiers                      | Storage  | Stats target | Description 
--------+-------------------+----------------------------------------------------+----------+--------------+-------------
 id     | integer           | not null default nextval('_todo_id_seq'::regclass) | plain    |              | 
 name   | character varying |                                                    | extended |              | 
 done   | boolean           |                                                    | plain    |              | 
Indexes:
    "_todo_pkey" PRIMARY KEY, btree (id)

postgres=# insert into _todo(name,done) values('a',true);
ERROR:  duplicate key value violates unique constraint "_todo_pkey"
DETAIL:  Key (id)=(1) already exists.
postgres=# delete from _todo where id=1;
DELETE 1
postgres=# select * from _todo;
 id | name | done 
----+------+------
(0 rows)

postgres=# insert into _todo(name,done) values('a',true);
INSERT 0 1
postgres=# select * from _todo;
 id | name | done 
----+------+------
  2 | a    | t
(1 row)

postgres=# insert into _todo(name,done) values('b',true);
INSERT 0 1
postgres=# select * from _todo;
 id | name | done 
----+------+------
  2 | a    | t
  3 | b    | t
(2 rows)

postgres=# drop table _tod;
DROP TABLE
postgres=# drop table _todo;
DROP TABLE
postgres=# \d+ _todo
                                             Table "public._todo"
 Column |  Type   |                     Modifiers                      | Storage  | Stats target | Description 
--------+---------+----------------------------------------------------+----------+--------------+-------------
 id     | bigint  | not null default nextval('_todo_id_seq'::regclass) | plain    |              | 
 name   | text    | not null                                           | extended |              | 
 done   | boolean | not null                                           | plain    |              | 
Indexes:
    "_todo_pkey" PRIMARY KEY, btree (id)

postgres=# 