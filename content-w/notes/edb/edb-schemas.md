+++
title = "EDB schemas"
author = ["Clint Jordan"]
description = " "
date = "2023-03-02"
lastmod = "2023-03-02"
tags = ["EDB"]
categories = ["notes"]
draft = false
+++

## Creating schemas

```text
db1=# CREATE SCHEMA IF NOT EXISTS schema_name [ AUTHORIZATION role-specification]
```

The `role-specification` here is the schema owner. It can be a user, group, or
a role. 

In Postgres, a user is *not* a schema. A user is a global object which exists
outside the database. Schemas are database level objects, so you must be
connected to the target database before creating one. A schema is a collection
of database tables, views, sequences, functions, and domains owned by a user.

Benefits of schemas:
* A database can contain one or more named schemas
* By default, all databases contain a public schema
* There are several reason to use schemas
    * to allow many users to use one database without interfereing with each
      other   
    * to organize database objects into logical groups to make them more
      manageable
    * third-party applications can be put into separate shemas so they cannot
      collide with the names of other objects

Example: if a depreciated application/user needs to be removed, its database
schema can be dropped instead of dropping all its objects individually.

Below is an example of creating a new database, new users, and new db schemas.

Create user1, user2, and user3. Users, groups, and roles are the same thing in
PostgreSQL, with the only difference being that users have permission to log in
by default. The CREATE USER and CREATE GROUP statements are actually aliases for
the CREATE ROLE statement.

{{< code-show-user  lang="sql" prompt="edb=#" output="2,3,5,6,8" cont-str="" cont-prompt=">" >}}
CREATE USER user1 PASSWORD '1';
CREATE ROLE

CREATE USER user2 PASSWORD '2';
CREATE ROLE

CREATE USER user3 PASSWORD '3';
CREATE ROLE
{{< /code-show-user >}}

Create a database called db1. It is owned by the superuser, enterprisedb.

{{< code-show-user  lang="sql" prompt="edb=#" output="2" cont-str="" cont-prompt=">" >}}
edb=# CREATE DATABASE db1;
CREATE DATABASE
{{< /code-show-user >}}

Revoke connect privilege from everyone excluding the owner and superuser(s).

{{< code-show-user  lang="sql" prompt="edb=#" output="2" cont-str="" cont-prompt=">" >}}
REVOKE CONNECT ON DATABASE db1 FROM public;
REVOKE
{{< /code-show-user >}}

Grant connect privilege to `user1` and `user3`;

{{< code-show-user  lang="sql" prompt="edb=#" output="2" cont-str="" cont-prompt=">" >}}
GRANT CONNECT ON DATABASE db1 TO user1, user3;
GRANT
{{< /code-show-user >}}

Connect to `db1` in order to create schemas.

{{< code-show-user  lang="sql" prompt="edb=#" output="2,3" cont-str="" cont-prompt=">" >}}
\c db1
(psql 13.4.8, server 13.4.8)
You are now connected to database "db1" as user "enterprisedb".
{{< /code-show-user >}}

Show list of schemas. The `public` schema owned by `enterprisedb` should be the
only one listed at this point.

{{< code-show-user  lang="sql" prompt="db1=#" output="2-10" cont-str="" cont-prompt=">" >}}
\dn
    List of schemas
  Name  |    Owner
--------+--------------
 public | enterprisedb
(1 row)
{{< /code-show-user >}}

Create a schema `user1` owned by the user/role `user1` and the same for `user3`. 

{{< code-show-user  lang="sql" prompt="db1=#" output="2,3,5" cont-str="" cont-prompt=">" >}}
CREATE SCHEMA IF NOT EXISTS user1 AUTHORIZATION user1;
CREATE SCHEMA

CREATE SCHEMA IF NOT EXISTS user3 AUTHORIZATION user3;
CREATE SCHEMA
{{< /code-show-user >}}

The list of schemas should now include `user1` and `user3`.

{{< code-show-user  lang="sql" prompt="db1=#" output="2-10" cont-str="" cont-prompt=">" >}}
\dn
    List of schemas
  Name  |    Owner
--------+--------------
 public | enterprisedb
 user1  | user1
 user3  | user3
(3 rows)
{{< /code-show-user >}}

Connect to `db1` as `user3`.

{{< code-show-user  lang="sql" prompt="db1=#" output="2-10" cont-str="" cont-prompt=">" >}}
\c db1 user3
Password for user user3:
psql (13.10.14, server 13.10.14)
You are now connected to database "db1" as user "user3".
{{< /code-show-user >}}

Create a table and insert a row.

{{< code-show-user  lang="sql" prompt="db1=>" output="2,3,5" cont-str="" cont-prompt=">" >}}
CREATE TABLE t1(i varchar);
CREATE TABLE

INSERT INTO t1 values('this is user3 data in t1');
INSERT 0 1
{{< /code-show-user >}}


{{< code-show-user  lang="sql" prompt="db1=>" output="2-10" cont-str="" cont-prompt=">" >}}
\dt
       List of relations
 Schema | Name | Type  | Owner
--------+------+-------+-------
 user3  | t1   | table | user3
(1 row)
{{< /code-show-user >}}

{{< code-show-user  lang="sql" prompt="db1=>" output="2-5,7-8,10-11,13-14,16-17,19-30" cont-str="" cont-prompt=">" >}}
\c db1 user1
Password for user user1:
psql (13.10.14, server 13.10.14)
You are now connected to database "db1" as user "user1".

create table t1(i varchar);
CREATE TABLE

create table t2(i varchar);
CREATE TABLE

INSERT INTO t1 values('this is user1 data in table t1');
INSERT 0 1

INSERT INTO t2 values('this is user1 data in table t2');
INSERT 0 1

\dt
       List of relations
 Schema | Name | Type  | Owner
--------+------+-------+-------
 user1  | t1   | table | user1
 user1  | t2   | table | user1
(1 row)
{{< /code-show-user >}}

Similar actions connected as `user1`. Notice how the two `t1` tables do not
interfere because they exists in separate schemas.

## Schema search path
The schema search path determines which schemas are searched for matching table
names. It is used when fully qualified object names are not used in a query.

Example: The following statement will find the first `employee` table from the
schemas listed in the search path.

{{< code-show-user  lang="sql" prompt="db1=#" output="2-10" cont-str="" cont-prompt=">" >}}
SELECT * FROM employee;
{{< /code-show-user >}}

Default search path. Schema `$user` will automatically be replaced with the
current user.

{{< code-show-user  lang="sql" prompt="db1=#" output="2-10" cont-str="" cont-prompt=">" >}}
SHOW search_path;
   search_path
-----------------
 "$user", public
(1 row)
{{< /code-show-user >}}

Setting the search path.

{{< code-show-user  lang="sql" prompt="db1=#" output="2-10" cont-str="" cont-prompt=">" >}}
SET search_path TO schema1, schema2, public;
{{< /code-show-user >}}

