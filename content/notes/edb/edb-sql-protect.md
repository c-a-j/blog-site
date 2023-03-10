+++
title = "SQL/Protect"
author = ["Clint Jordan"]
description = " "
date = "2023-03-06"
lastmod = "2023-03-10"
tags = ["edb"]
categories = ["notes"]
draft = false
+++

## Installation

For Linux, install the `edb-asxx-server-sqlprotect` RPM package where `xx` is the
EDB Postgres Advanced Server version number.

```text
yum install edb-as13-server-sqlprotect
```

> Note: After following the installation procedure in the EPAS13 RN,
> `edb-as13-server-sqlprotect` was already installed.

## Initial configuration

### Modify the `postgresql.conf` file
```text
# Shared Preload Libraries
shared_preload_libraries = '$libdir/sqlprotect'

# SQL/Protect settings
edb_sql_protect.enabled = off
edb_sql_protect.level = learn
edb_sql_protect.max_protected_roles = 64
edb_sql_protect.max_protected_relations = 1024
edb_sql_protect.max_queries_to_save = 5000
```

## Testing procedures
Three different scenarios need to be tested

1. Import SQL/Protect data from a backup to a newly restored database.
    * this is possible per [edb documentation](https://www.enterprisedb.com/docs/epas/latest/epas_security_guide/02_protecting_against_sql_injection_attacks/04_backing_up_restoring_sql_protect/)
    * it is unclear whether the "learned" data is also imported, but this is
      currently assumed to be the case
2. Import SQL/Protect "learned" data from a dev/test cluster to a production
   cluster
    * currently unclear if this is possible
3. Import SQL/Protect "learned" data from a backup to a newly updated/patched
   database

### Scenario 1: Importing from a backup within the same cluster

#### Step 1: Create database, roles, schemas, and tables

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
GRANT ROLE group1 TO user2, user3;
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

##### Create tables in the `user1` schema
Connect as `user1`.
{{< code-show-user lang="sql" prompt="db01d=#" output="2-4" cont-str="" cont-prompt="->">}}
\c db1 user1
Password for user user1:
psql (13.10.14, server 13.10.14)
You are now connected to database "db1" as user "user1".
{{< /code-show-user >}}

Create tables 
{{< code-show-user lang="sql" prompt="db01d=>" output="2-4" cont-str="" cont-prompt="->">}}
CREATE TABLE t1(i varchar);
{{< /code-show-user >}}

Insert data into tables
{{< code-show-user lang="sql" prompt="db01d=>" output="2-4" cont-str="" cont-prompt="->">}}
INSERT INTO t1 values('this is user3 data in t1');
{{< /code-show-user >}}


##### Create tables in the `user2` schema
##### Create tables in the `user3` schema
##### Create tables in the `user4` schema
##### Create tables in the `group1` schema


##### Grouped commands
```sql
CREATE DATABASE db01d;
CREATE USER user1 PASSWORD 'pw1';
CREATE USER user2 PASSWORD 'pw2';
CREATE USER user3 PASSWORD 'pw3';
CREATE USER user4 PASSWORD 'pw4';
CREATE ROLE group1 IDENTIFIED BY 'pwg1';
```


#### Step 2: Create a backup the database
* **these steps are currently unverified**
{{< alert >}}This is an alert.{{< /alert >}}

Backup database with the `pg_dump` utility.
{{< code-show-user lang="text" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
cd /usr/edb/as14/bin
./pg_dump -U enterprisedb -Fp -f /tmp/db01d.dmp db01d
{{< /code-show-user >}}
> Note: `/usr/edb/as13` has already been added to `enterprisedb`'s path so
> changing directories will not be necessary

#### Step 3: Enable SQL/Protect in learn mode

#### Step 4: Run test suite

#### Step 5: Export SQL/Protect data

#### Step 6: Restore the database

#### Step 7: Import SQL/Protect data

#### Step 8: Enable active mode

#### Step 9: Run test suite

#### Step 10: Run second test suit
Run commands that will be blocked by SQL/Protect to ensure learned behavior has
been transferred.


### Scenario 2: Importing between clusters
Two clusters will be used to simulate dev/test and production environments. The
purpose of this test is to ensure that SQL/Protect data can be transferred
between clusters.

#### Step 1: Create database, roles, schemas, and tables
Run identical steps on both databases.

#### Step 2: Run through Scenario 1 on the dev/test cluster

#### Step 4: Import SQL/Protect data into production cluster

#### Step 5: Enable active mode

#### Step 6: Run test suite in production
These learned commands should not be blocked.

#### Step 7: Run second test suite in production
This test suite should contain commands that will be blocked by SQL/Protect.


