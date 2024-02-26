+++
title = "SQL/Protect - import/export between DB clusters"
author = ["Clint Jordan"]
description = "Migrating SQL/Protect data between clusters"
date = "2023-03-06"
lastmod = "2023-03-14"
tags = ["edb","sql protect"]
categories = ["notes"]
draft = false
autonumber = false
printmode = true
+++

## Testing procedure overview
The intention of this test is to demonstrate that SQL/Protect data can be
transferred between two EPAS database clusters, which will allow production
servers to remain in active mode at all times. Most of the steps found in this
test were taken directly from the [edb
documentation](https://www.enterprisedb.com/docs/epas/latest/epas_security_guide/02_protecting_against_sql_injection_attacks/04_backing_up_restoring_sql_protect/).

## Step 1: Cluster setup

### Create the clusters
Create a cluster to simulate a production environment
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
initdb -D ~/as13/data_p
{{< /code-show-user >}}

Create a cluster to simulate a development environment
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
initdb -D ~/as13/data_d
{{< /code-show-user >}}

Correct the `PGDATA` variables
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
export PGDATA_D="/var/lib/edb/as13/data_d"
export PGDATA_P="/var/lib/edb/as13/data_p"
{{< /code-show-user >}}


### Modify the `postgresql.conf` files
Append the following lines to the production configuration file (`$PGDATA_P/postgresql.conf`):
```text
# Shared Preload Libraries
shared_preload_libraries = '$libdir/sqlprotect'

# SQL/Protect settings
edb_sql_protect.enabled = on
edb_sql_protect.level = active
edb_sql_protect.max_protected_roles = 64
edb_sql_protect.max_protected_relations = 1024
edb_sql_protect.max_queries_to_save = 5000
```

Append the following lines to the development configuration file (`$PGDATA_D/postgresql.conf`):
```text
# Shared Preload Libraries
shared_preload_libraries = '$libdir/sqlprotect'

# SQL/Protect settings
edb_sql_protect.enabled = on
edb_sql_protect.level = learn
edb_sql_protect.max_protected_roles = 64
edb_sql_protect.max_protected_relations = 1024
edb_sql_protect.max_queries_to_save = 5000~/as13/data_d
```

### Start the clusters
Start both clusters
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
pg_ctl -D ~/as13/data_p -o "-p 5444" start
pg_ctl -D ~/as13/data_d -o "-p 5443" start
{{< /code-show-user >}}

### Connect to a cluster
Connecting to a cluster
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5444"
{{< /code-show-user >}}

### Ensure that SQL/Protect is enabled
Production
{{< code-show-user lang="sql" prompt="edb=#" output="2-6,8-12,14-20" cont-str="" cont-prompt="->">}}
show shared_preload_libraries; 
 shared_preload_libraries
 --------------------------
  $libdir/sqlprotect
  (1 row)

show edb_sql_protect.enabled; 
 edb_sql_protect.enabled
 -------------------------
  on
  (1 row)

show edb_sql_protect.level;
 edb_sql_protect.level
 -----------------------
  active
  (1 row)
{{< /code-show-user >}}

Development
{{< code-show-user lang="sql" prompt="edb=#" output="2-6,8-12,14-20" cont-str="" cont-prompt="->">}}
show shared_preload_libraries; 
 shared_preload_libraries
 --------------------------
  $libdir/sqlprotect
  (1 row)

show edb_sql_protect.enabled; 
 edb_sql_protect.enabled
 -------------------------
  on
  (1 row)

show edb_sql_protect.level;
 edb_sql_protect.level
 -----------------------
  learn
  (1 row)
{{< /code-show-user >}}

## Step 2: Create databases, roles, and schemas

### Production cluster
Create database `db01p`
{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
CREATE DATABASE db01p;
{{< /code-show-user >}}

Connect to database
{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
\c db01p
{{< /code-show-user >}}

Create the `sqlprotect` schema and objects
{{< code-show-user lang="text" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
\i /usr/edb/as13/share/contrib/sqlprotect.sql
{{< /code-show-user >}}

Create user and schema
{{< code-show-user lang="sql" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
create schema test;
create user test;
alter schema test owner to test;
{{< /code-show-user >}}

Protect the new role, `test`
{{< code-show-user lang="sql" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.protect_role('test');
{{< /code-show-user >}}

View the protected users
{{< code-show-user lang="sql" prompt="db01p=#" output="2-10" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.list_protected_users;
  dbname  | username | protect_relations | allow_utility_cmds | allow_tautology | allow_empty_dml
----------+----------+-------------------+--------------------+-----------------+-----------------
 cluster1 | test     | t                 | f                  | f               | f
(1 row)
{{< /code-show-user >}}

Restart `psql` so new settings are active
{{< code-show-user lang="sql" prompt="db01p=#" output="2-10" cont-str="" cont-prompt="->">}}
\q
{{< /code-show-user >}}

{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5444"
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
\c db01p
{{< /code-show-user >}}

Create tables
{{< code-show-user lang="sql" prompt="db01p=#" output="4" cont-str="" cont-prompt="->">}}
create table test_table(i int);
insert into test_table select generate_series(1,100);
grant select on table test_table to test;

create table another_test_table(i int);
insert into another_test_table select generate_series(1,100);
grant select on table another_test_table to test;
grant insert on table another_test_table to test;
{{< /code-show-user >}}

Attempt to query tables with user `test`
{{< code-show-user lang="sql" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
set role test;
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01p=>" output="2,3,5,6,8" cont-str="" cont-prompt="->">}}
select * from test_table limit 10;
ERROR:  SQLPROTECT: Illegal Query: relations

select * from another_test_table limit 10;
ERROR:  SQLPROTECT: Illegal Query: relations

insert into another_test_table select generate_series(1,100);
ERROR:  SQLPROTECT: Illegal Query: relations
{{< /code-show-user >}}

Check the `roleid` for the user `test`
{{< code-show-user lang="sql" prompt="db01p=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT usesysid FROM pg_user WHERE usename='test';
 usesysid
----------
    16428
(1 row)
{{< /code-show-user >}}

View the protected roles with OIDs (Object IDs).
{{< code-show-user lang="sql" prompt="db01p=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.edb_sql_protect;
 dbid  | roleid | protect_relations | allow_utility_cmds | allow_tautology | allow_empty_dml
-------+--------+-------------------+--------------------+-----------------+-----------------
 16384 |  16428 | t                 | f                  | f               | f
(1 row)
{{< /code-show-user >}}

View the protected roles with the object names.
{{< code-show-user lang="sql" prompt="db01p=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.list_protected_users;
 dbname | username | protect_relations | allow_utility_cmds | allow_tautology | allow_empty_dml
--------+----------+-------------------+--------------------+-----------------+-----------------
 db01p  | test     | t                 | f                  | f               | f
(1 row)
{{< /code-show-user >}}

Set the `protect_relations` field to `'f'`
{{< code-show-user lang="sql" prompt="db01p=#" output="2,3,5-10" cont-str="" cont-prompt="->">}}
update sqlprotect.edb_sql_protect set protect_relations='f' where dbid=16384 and roleid=16428;
UPDATE 1

SELECT * FROM sqlprotect.list_protected_users;
 dbname | username | protect_relations | allow_utility_cmds | allow_tautology | allow_empty_dml
--------+----------+-------------------+--------------------+-----------------+-----------------
 db01p  | test     | f                 | f                  | f               | f
(1 row)
{{< /code-show-user >}}

Restart `psql` so new settings are active
{{< code-show-user lang="sql" prompt="db01p=#" output="2-10" cont-str="" cont-prompt="->">}}
\q
{{< /code-show-user >}}

{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5444"
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
\c db01p
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01p=#" output="2-10" cont-str="" cont-prompt="->">}}
set role test;
{{< /code-show-user >}}

Now attempt to query the tables again
{{< code-show-user lang="sql" prompt="db01p=>" output="2-8,10-16,18" cont-str="" cont-prompt="->">}}
select * from test_table limit 3;
 i
----
  1
  2
  3
(3 rows)

select * from another_test_table limit 3;
 i
----
  1
  2
  3
(3 rows)

insert into another_test_table select generate_series(1,100);
INSERT 0 100
{{< /code-show-user >}}

### Development cluster

Create database `db01d`
{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
CREATE DATABASE db01d;
{{< /code-show-user >}}

Connect to database
{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
\c db01d
{{< /code-show-user >}}

Create the `sqlprotect` schema and objects
{{< code-show-user lang="text" prompt="db01d=#" output="" cont-str="" cont-prompt="->">}}
\i /usr/edb/as13/share/contrib/sqlprotect.sql
{{< /code-show-user >}}

At this point, the two clusters are exactly the same down to the OIDs. For the
development test cluster additional users and tables will be created to ensure
that the OIDs between the objects of interest are different.
{{< code-show-user lang="sql" prompt="db01d=#" output="4,8,12" cont-str="" cont-prompt="->">}}
create schema user1;
create user user1;
alter schema user1 owner to user1;

create schema user2;
create user user2;
alter schema user2 owner to user2;

create schema user3;
create user user3;
alter schema user3 owner to user3;

create schema test;
create user test;
alter schema test owner to test;
{{< /code-show-user >}}

Protect the new role, `test`
{{< code-show-user lang="sql" prompt="db01d=#" output="" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.protect_role('test');
{{< /code-show-user >}}

View the protected users
{{< code-show-user lang="sql" prompt="db01d=#" output="2-10" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.list_protected_users;
  dbname  | username | protect_relations | allow_utility_cmds | allow_tautology | allow_empty_dml
----------+----------+-------------------+--------------------+-----------------+-----------------
 cluster1 | test     | t                 | f                  | f               | f
(1 row)
{{< /code-show-user >}}

Restart `psql` so new settings are active
{{< code-show-user lang="sql" prompt="db01d=#" output="2-10" cont-str="" cont-prompt="->">}}
\q
{{< /code-show-user >}}

{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5443"
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
\c db01d
{{< /code-show-user >}}

Create tables
{{< code-show-user lang="sql" prompt="db01d=#" output="4,8,12,16" cont-str="" cont-prompt="->">}}
create table t1(i int);
insert into t1 select generate_series(1,100);
grant select on table t1 to user1;

create table t2(i int);
insert into t2 select generate_series(1,100);
grant select on table t2 to user2;

create table t3(i int);
insert into t3 select generate_series(1,100);
grant select on table t3 to user3;

create table test_table(i int);
insert into test_table select generate_series(1,100);
grant select on table test_table to test;

create table another_test_table(i int);
insert into another_test_table select generate_series(1,100);
grant select on table another_test_table to test;
grant insert on table another_test_table to test;
{{< /code-show-user >}}

Execute queries with user `test`
{{< code-show-user lang="sql" prompt="db01d=#" output="2-10" cont-str="" cont-prompt="->">}}
set role test;
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01d=>" output="2,3" cont-str="" cont-prompt="->">}}
create table yet_another_test_table(i int);
NOTICE:  SQLPROTECT: This command type is illegal for this user
CREATE TABLE
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01d=>" output="2,3" cont-str="" cont-prompt="->">}}
insert into yet_another_test_table select generate_series(1,100);
NOTICE:  SQLPROTECT: Learned relation: 16453
INSERT 0 100
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01p=>" output="2-9,11-18,20" cont-str="" cont-prompt="->">}}
select * from test_table limit 3;
NOTICE:  SQLPROTECT: Learned relation: 16444
 i
---
 1
 2
 3
(3 rows)

select * from another_test_table limit 3;
NOTICE:  SQLPROTECT: Learned relation: 16447
 i
---
 1
 2
 3
(3 rows)

insert into another_test_table select generate_series(1,100); 
INSERT 0 100
{{< /code-show-user >}}

Check the `roleid` for the user `test`
{{< code-show-user lang="sql" prompt="db01d=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT usesysid FROM pg_user WHERE usename='test';
 usesysid
----------
    16434
(1 row)
{{< /code-show-user >}}

View the protected roles with OIDs (Object IDs).
{{< code-show-user lang="sql" prompt="db01d=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.edb_sql_protect;
 dbid  | roleid | protect_relations | allow_utility_cmds | allow_tautology | allow_empty_dml
-------+--------+-------------------+--------------------+-----------------+-----------------
 16384 |  16434 | t                 | f                  | f               | f
(1 row)
{{< /code-show-user >}}

View the protected roles with the object names.
{{< code-show-user lang="sql" prompt="db01d=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.list_protected_users;
 dbname | username | protect_relations | allow_utility_cmds | allow_tautology | allow_empty_dml
--------+----------+-------------------+--------------------+-----------------+-----------------
 db01d  | test     | t                 | f                  | f               | f
(1 row)
{{< /code-show-user >}}

## Step 3: Export and Import

### Export data from development
{{< code-show-user lang="sql" prompt="db01d=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.export_sqlprotect('/var/lib/edb/as13/backups/sqlprotect.dmp');
 export_sqlprotect
-------------------

(1 row)
{{< /code-show-user >}}


### Delete all SQL/Protect data from production
Drop relations
{{< code-show-user lang="sql" prompt="db01p=#" output="2,4" cont-str="" cont-prompt="->">}}
DELETE FROM sqlprotect.edb_sql_protect_rel;
DELETE 0
DELETE FROM sqlprotect.edb_sql_protect;
DELETE 1
{{< /code-show-user >}}

Drop user query statistics
{{< code-show-user lang="sql" prompt="db01p=#" output="2-6" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.edb_sql_protect_stats;
 username | superusers | relations | commands | tautology | dml
----------+------------+-----------+----------+-----------+-----
 test     |          0 |         3 |        0 |         0 |   0

(1 row)
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01p=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.drop_stats('test');
 drop_stats
------------

(1 row)
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01p=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.edb_sql_protect_stats;
 username | superusers | relations | commands | tautology | dml
----------+------------+-----------+----------+-----------+-----

(0 rows)
{{< /code-show-user >}}

Drop queries
{{< code-show-user lang="sql" prompt="db01p=#" output="2-100" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.edb_sql_protect_queries;
 username | ip_address | port | machine_name |         date_time         |                               query
----------+------------+------+--------------+---------------------------+-------------------------------------------------------------------
 test     |            |      |              | 22-MAR-23 19:03:00 -05:00 | select * from another_test_table limit 10;
 test     |            |      |              | 22-MAR-23 19:03:00 -05:00 | SELECT r.rolname, r.rolsuper, r.rolinherit,                      +
          |            |      |              |                           |   r.rolcreaterole, r.rolcreatedb, r.rolcanlogin,                 +
          |            |      |              |                           |   r.rolconnlimit, r.rolvaliduntil,                               +
          |            |      |              |                           |   ARRAY(SELECT b.rolname                                         +
          |            |      |              |                           |         FROM pg_catalog.pg_auth_members m                        +
          |            |      |              |                           |         JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)         +
          |            |      |              |                           |         WHERE m.member = r.oid) as memberof                      +
          |            |      |              |                           | , pg_catalog.shobj_description(r.oid, 'pg_authid') AS description+
          |            |      |              |                           | , r.rolreplication                                               +
          |            |      |              |                           | , r.rolbypassrls                                                 +
          |            |      |              |                           | , r.rolprofile                                                   +
          |            |      |              |                           | , edb_get_role_status(r.oid)                                     +
          |            |      |              |                           | , edb_get_password_expiry_date(r.oid)                            +
          |            |      |              |                           | , r.rollockdate                                                  +
          |            |      |              |                           | FROM pg_catalog.pg_roles r                                       +
          |            |      |              |                           | WHERE r.rolname !~ '^pg_'                                        +
          |            |      |              |                           | ORDER BY 1;
 test     |            |      |              | 22-MAR-23 19:03:00 -05:00 | select * from test_table limit 10;

(3 rows)
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01p=#" output="2-100" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.drop_queries('test');
 drop_queries
--------------
            3
(1 row)
{{< /code-show-user >}}

### Import data into production
{{< code-show-user lang="sql" prompt="db01p=#" output="2-100" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.import_sqlprotect('/var/lib/edb/as13/backups/sqlprotect.dmp');
 import_sqlprotect
-------------------

(1 row)
{{< /code-show-user >}}

## Step 4: Verifications

Restart `psql` so new settings are active
{{< code-show-user lang="sql" prompt="db01p=#" output="2-10" cont-str="" cont-prompt="->">}}
\q
{{< /code-show-user >}}

{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5444"
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
\c db01p
{{< /code-show-user >}}

Verify that production DB is still in active mode
{{< code-show-user lang="sql" prompt="db01p=#" output="2-5" cont-str="" cont-prompt="->">}}
show edb_sql_protect.level;
{{< /code-show-user >}}

Verify that the `protect_relations` parameter is now set to `t`
{{< code-show-user lang="sql" prompt="db01p=#" output="2-5" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.list_protected_users;
 dbname | username | protect_relations | allow_utility_cmds | allow_tautology | allow_empty_dml
--------+----------+-------------------+--------------------+-----------------+-----------------
 db01p  | test     | t                 | f                  | f               | f
(1 row)
{{< /code-show-user >}}

Verify learned relations
{{< code-show-user lang="sql" prompt="db01p=#" output="2-10" cont-str="" cont-prompt="->">}}
set role test;
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01p=>" output="2-8,10-16,18-19,21" cont-str="" cont-prompt="->">}}
select * from test_table limit 3;
 i
---
 1
 2
 3
(3 rows)

select * from another_test_table limit 3;
 i
---
 1
 2
 3
(3 rows)

insert into another_test_table select generate_series(1,100);
INSERT 0 100

create table yet_another_test_table(i int);
ERROR:  SQLPROTECT: This command type is illegal for this user
{{< /code-show-user >}}
