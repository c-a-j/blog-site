+++
title = "SQL/Protect Testing"
author = ["Clint Jordan"]
description = "Migrating SQL/Protect data between clusters"
date = "2023-03-06"
lastmod = "2023-03-14"
tags = ["edb","sql protect"]
categories = ["notes"]
draft = false
+++

## Testing procedure overview
There are three different maintenance scenarios that will be frequently 
encountered.

1. Import SQL/Protect data from a backup to a newly restored database.
    * this is possible per [edb documentation](https://www.enterprisedb.com/docs/epas/latest/epas_security_guide/02_protecting_against_sql_injection_attacks/04_backing_up_restoring_sql_protect/)
2. Import SQL/Protect "learned" data from a dev/test cluster to a production
   cluster
    * currently unclear if this is possible
3. Import SQL/Protect "learned" data from a backup to a newly updated/patched
   database

Scenario 1 is found explicitly in the EDB documentation, so testing for scenario
2 can reasonably serve for both 1 and 2. Scenario 3 will depend entirely on EDB
maintaining SQL/Protect compatibility between versions, so this will not be
tested until EPAS is upgraded.


## Scenario 2: Importing between clusters

### Step 1: Create test clusters

Create a cluster to simulate development environment
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
initdb -D ~/as13/data_db01d
{{< /code-show-user >}}

Create a cluster to simulate production environment
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
initdb -D ~/as13/data_db01p
{{< /code-show-user >}}

Start both clusters
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
pg_ctl -D ~/as13/data_db01d -o "-p 5443" start
pg_ctl -D ~/as13/data_db01p -o "-p 5444" start
{{< /code-show-user >}}

Connecting to a cluster
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5443"
{{< /code-show-user >}}

### Step 2: Create databases, roles, and schemas

Create database and roles. In this case there will be four user roles and
a single group role.
{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
CREATE DATABASE db01d;
CREATE USER user1 PASSWORD 'pw1';
CREATE USER user2 PASSWORD 'pw2';
CREATE USER user3 PASSWORD 'pw3';
CREATE USER user4 PASSWORD 'pw4';
CREATE ROLE group1 IDENTIFIED BY 'pwg1';
{{< /code-show-user >}}

Ensure that new users (public schema) do not have the ability to connect by
default via the `public` schema.
{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
REVOKE CONNECT ON DATABASE db01d FROM public;
{{< /code-show-user >}}

Grant the connect privilege to all newly created users.
{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
GRANT CONNECT ON DATABASE db1 TO user1, user2, user3, user4;
{{< /code-show-user >}}

Grant the `group1` role to a specific set of users.
{{< code-show-user lang="sql" prompt="edb=#" output="" cont-str="" cont-prompt="->">}}
GRANT group1 TO user2, user3;
{{< /code-show-user >}}

Connect to database to create schemas (reminder: schemas are db level objects).
{{< code-show-user lang="sql" prompt="edb=#" output="2,3" cont-str="" cont-prompt="->">}}
\c db01d
(psql 13.4.8, server 13.4.8)
You are now connected to database "db01d" as user "enterprisedb".
{{< /code-show-user >}}

Create schemas for each user/role.
{{< code-show-user lang="sql" prompt="db01d=#" output="" cont-str="" cont-prompt="->">}}
CREATE SCHEMA IF NOT EXISTS user1 AUTHORIZATION user1;
CREATE SCHEMA IF NOT EXISTS user2 AUTHORIZATION user2;
CREATE SCHEMA IF NOT EXISTS user3 AUTHORIZATION user3;
CREATE SCHEMA IF NOT EXISTS user4 AUTHORIZATION user4;
CREATE SCHEMA IF NOT EXISTS group1 AUTHORIZATION group1;
{{< /code-show-user >}}



#### Grouped commands
Create database and roles on development cluster.
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5443"
{{< /code-show-user >}}
```sql
CREATE DATABASE db01d;
CREATE USER user1 PASSWORD 'pw1';
CREATE USER user2 PASSWORD 'pw2';
CREATE USER user3 PASSWORD 'pw3';
CREATE USER user4 PASSWORD 'pw4';
CREATE ROLE group1 IDENTIFIED BY 'pwg1';

REVOKE CONNECT ON DATABASE db01d FROM public;
GRANT CONNECT ON DATABASE db01d TO user1, user2, user3, user4;
GRANT group1 TO user2;
GRANT group1 TO user3;

\c db01d;

CREATE SCHEMA IF NOT EXISTS user1 AUTHORIZATION user1;
CREATE SCHEMA IF NOT EXISTS user2 AUTHORIZATION user2;
CREATE SCHEMA IF NOT EXISTS user3 AUTHORIZATION user3;
CREATE SCHEMA IF NOT EXISTS user4 AUTHORIZATION user4;
CREATE SCHEMA IF NOT EXISTS group1 AUTHORIZATION group1;
CREATE TABLE group1.t1(i VARCHAR);
GRANT INSERT ON group1.t1 TO user2;
GRANT INSERT ON group1.t1 TO user3;
```

Create database and roles on production cluster.
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5444"
{{< /code-show-user >}}
```sql
CREATE DATABASE db01p;
CREATE USER user1 PASSWORD 'pw1';
CREATE USER user2 PASSWORD 'pw2';
CREATE USER user3 PASSWORD 'pw3';
CREATE USER user4 PASSWORD 'pw4';
CREATE ROLE group1 IDENTIFIED BY 'pwg1';

REVOKE CONNECT ON DATABASE db01p FROM public;
GRANT CONNECT ON DATABASE db01p TO user1, user2, user3, user4;
GRANT group1 TO user2;
GRANT group1 TO user3;

\c db01p;

CREATE SCHEMA IF NOT EXISTS user1 AUTHORIZATION user1;
CREATE SCHEMA IF NOT EXISTS user2 AUTHORIZATION user2;
CREATE SCHEMA IF NOT EXISTS user3 AUTHORIZATION user3;
CREATE SCHEMA IF NOT EXISTS user4 AUTHORIZATION user4;
CREATE SCHEMA IF NOT EXISTS group1 AUTHORIZATION group1;
CREATE TABLE group1.t1(i VARCHAR);
GRANT INSERT ON group1.t1 TO user2;
GRANT INSERT ON group1.t1 TO user3;
```

### Step 3: Enable and configure SQL/Protect

#### Modify the `postgresql.conf` file
Development version (`/as13/data_db01d/postgresql.conf`):
```text
# Shared Preload Libraries
shared_preload_libraries = '$libdir/sqlprotect'

# SQL/Protect settings
edb_sql_protect.enabled = on
edb_sql_protect.level = learn
edb_sql_protect.max_protected_roles = 64
edb_sql_protect.max_protected_relations = 1024
edb_sql_protect.max_queries_to_save = 5000
```

Production version (`/as13/data_db01p/postgresql.conf`):
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

#### Restart the database servers
{{< code-show-user lang="text" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
pg_ctl -D ~/as13/data_db01d -o "-p 5443" stop
pg_ctl -D ~/as13/data_db01p -o "-p 5444" stop
{{< /code-show-user >}}
{{< code-show-user lang="text" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
pg_ctl -D ~/as13/data_db01d -o "-p 5443" start
pg_ctl -D ~/as13/data_db01p -o "-p 5444" start
{{< /code-show-user >}}

#### Run SQL/Protect script as superuser
{{< code-show-user lang="text" prompt="db01d=#" output="" cont-str="" cont-prompt="->">}}
\i /usr/edb/as13/share/contrib/sqlprotect.sql
{{< /code-show-user >}}

{{< code-show-user lang="text" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
\i /usr/edb/as13/share/contrib/sqlprotect.sql
{{< /code-show-user >}}

#### Add roles to the protected list
Include the `sqlprotect` schema  in the search path.
{{< code-show-user lang="text" prompt="db01d=#" output="" cont-str="" cont-prompt="->">}}
SET search_path TO sqlprotect;
{{< /code-show-user >}}

Add roles to the protected list.
{{< code-show-user lang="text" prompt="db01d=#" output="" cont-str="" cont-prompt="->">}}
SELECT protect_role('user1');
SELECT protect_role('user2');
SELECT protect_role('user3');
SELECT protect_role('user4');
SELECT protect_role('group1');
{{< /code-show-user >}}

Enable expanded display.
{{< code-show-user lang="text" prompt="db01d=#" output="" cont-str="" cont-prompt="->">}}
\x
Expanded display is on.
{{< /code-show-user >}}

View the protected roles with OIDs.
{{< code-show-user lang="text" prompt="db01d=#" output="2,4-100" cont-str="" cont-prompt="->">}}
SELECT * FROM edb_sql_protect;
-[ RECORD 1 ]------+------
dbid               | 16641
roleid             | 16642
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
-[ RECORD 2 ]------+------
dbid               | 16641
roleid             | 16643
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
-[ RECORD 3 ]------+------
dbid               | 16641
roleid             | 16644
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
-[ RECORD 4 ]------+------
dbid               | 16641
roleid             | 16645
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
-[ RECORD 5 ]------+------
dbid               | 16641
roleid             | 16646
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
{{< /code-show-user >}}

View the protected roles with object names.
{{< code-show-user lang="text" prompt="db01d=#" output="2-100" cont-str="" cont-prompt="->">}}
SELECT * FROM list_protected_users;
-[ RECORD 1 ]------+-------
dbname             | db01d
username           | user1
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
-[ RECORD 2 ]------+-------
dbname             | db01d
username           | user2
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
-[ RECORD 3 ]------+-------
dbname             | db01d
username           | user3
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
-[ RECORD 4 ]------+-------
dbname             | db01d
username           | user4
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f
-[ RECORD 5 ]------+-------
dbname             | db01d
username           | group1
protect_relations  | t
allow_utility_cmds | f
allow_tautology    | f
allow_empty_dml    | f

{{< /code-show-user >}}

### Step 4: Run test suite

#### Create tables with `user1`
Connect as `user1`.
{{< code-show-user lang="sql" prompt="db01d=#" output="2-4" cont-str="" cont-prompt="->">}}
\c db01d user1
Password for user user1:
psql (13.10.14, server 13.10.14)
You are now connected to database "db01d" as user "user1".
{{< /code-show-user >}}

Create table
{{< code-show-user lang="sql" prompt="db01d=>" output="2-4" cont-str="" cont-prompt="->">}}
CREATE TABLE t1(i varchar);
{{< /code-show-user >}}

Insert data into tables
{{< code-show-user lang="sql" prompt="db01d=>" output="2-4" cont-str="" cont-prompt="->">}}
INSERT INTO t1 values('this is user3 data in user1.t1');
INSERT INTO user4.t1 values('this is more user4 data in user4.t1');
{{< /code-show-user >}}

#### Create tables with `user2`
{{< code-show-user lang="sql" prompt="db01d=#" output="2-4" cont-str="" cont-prompt="->">}}
\c db01d user2
Password for user user2:
psql (13.10.14, server 13.10.14)
You are now connected to database "db01d" as user "user2".
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01d=>" output="" cont-str="" cont-prompt="->">}}
create table user2.t1(i VARCHAR);
INSERT INTO user2.t1 values('this is user2 data in user2.t1');
INSERT INTO user2.t1 values('this is more user2 data in user2.t1');
INSERT INTO group1.t1 values('this is user2 data in group1.t1');
{{< /code-show-user >}}

#### Create tables with `user3`
{{< code-show-user lang="sql" prompt="db01d=#" output="2-4" cont-str="" cont-prompt="->">}}
\c db01d user3
Password for user user3:
psql (13.10.14, server 13.10.14)
You are now connected to database "db01d" as user "user3".
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01d=>" output="" cont-str="" cont-prompt="->">}}
create table user3.t1(i VARCHAR);
INSERT INTO user3.t1 values('this is user3 data in user3.t1');
INSERT INTO user3.t1 values('this is more user3 data in user3.t1');
INSERT INTO group1.t1 values('this is user3 data in group1.t1');
{{< /code-show-user >}}

#### Create tables with `user4`
{{< code-show-user lang="sql" prompt="db01d=#" output="2-4" cont-str="" cont-prompt="->">}}
\c db01d user4
Password for user user4:
psql (13.10.14, server 13.10.14)
You are now connected to database "db01d" as user "user4".
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="db01d=>" output="" cont-str="" cont-prompt="->">}}
create table user4.t1(i VARCHAR);
INSERT INTO user4.t1 values('this is user4 data in user4.t1');
INSERT INTO user4.t1 values('this is more user4 data in user4.t1');
{{< /code-show-user >}}

Create tables script.
```sql
\c db01d user1;
create table user1.t1(i VARCHAR);
INSERT INTO user1.t1 values('this is user1 data in t1');
INSERT INTO user1.t1 values('this is more user1 data in t1');

\c db01d user2;
create table user2.t1(i VARCHAR);
INSERT INTO user2.t1 values('this is user2 data in user2.t1');
INSERT INTO user2.t1 values('this is more user2 data in user2.t1');
INSERT INTO group1.t1 values('this is user2 data in group1.t1');

\c db01d user3;
create table user3.t1(i VARCHAR);
INSERT INTO user3.t1 values('this is user3 data in user3.t1');
INSERT INTO user3.t1 values('this is more user3 data in user3.t1');
INSERT INTO group1.t1 values('this is user3 data in group1.t1');

\c db01d user4;
create table user4.t1(i VARCHAR);
INSERT INTO user4.t1 values('this is user4 data in user4.t1');
INSERT INTO user4.t1 values('this is more user4 data in user4.t1');
```

#### Optional: enable active mode on development database
Set `edb_sql_protect.level = active` in `/as13/data_db01d/postgresql.conf`.
Reload `/as13/data_db01d/postgresql.conf` after modification.
{{< code-show-user lang="text" prompt="enterprisedb $" output="2" cont-str="" cont-prompt=">" >}}
pg_ctl reload -D as13/data_db01d/
server signaled
{{< /code-show-user >}}

### Step 5: Export SQL/Protect data
{{< code-show-user lang="text" prompt="db01d=#" output="" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.export_sqlprotect('/var/lib/edb/as13/backups/sqlprotect.dmp');
{{< /code-show-user >}}


### Step 6: Import SQL/Protect data into production
For this test, there wasn't any data in the SQL/Protect objects, but for a real
import, data would need to be removed from the objects so that the OIDs can be
corrected upon import.

{{< code-show-user lang="text" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
DELETE FROM sqlprotect.edb_sql_protect_rel;
DELETE FROM sqlprotect.edb_sql_protect;
{{< /code-show-user >}}

Check for existing statistics.
{{< code-show-user lang="text" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.edb_sql_protect_stats;
{{< /code-show-user >}}

If they do exist, drop them for each role.
{{< code-show-user lang="text" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.drop_stats('user');
{{< /code-show-user >}}

Check for existing offending queries.
{{< code-show-user lang="text" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
SELECT * FROM sqlprotect.edb_sql_protect_queries;
{{< /code-show-user >}}

If they do exist, drop them for each role.
{{< code-show-user lang="text" prompt="db01p=#" output="" cont-str="" cont-prompt="->">}}
SELECT sqlprotect.drop_queries('user');
{{< /code-show-user >}}

### Step 7: Import SQL/Protect data
> **Critical**: the role names that were protected by SQL/Protect in the development
> cluster **must** exist in the production cluster.



### Step 8: Enable active mode

### Step 9: Run test suite

### Step 10: Run second test suit
Run commands that will be blocked by SQL/Protect to ensure learned behavior has
been transferred.
