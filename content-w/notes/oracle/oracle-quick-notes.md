+++
title = "Oracle Quick Notes"
author = ["Clint Jordan"]
description = " "
date = "2023-04-25"
lastmod = ""
tags = ["oracle", "sql-plus"]
categories = ["notes"]
draft = false
autonumber = false
printmode = false
+++


## View the latest RMAN backups
 
```sql
select * from v$backup_set
where completion_time > sysdate-7
order by completion_time desc
offset 0 rows fetch next 1 rows only;
```


## Get object information
```sql
select owner, object_name, object_type
from ALL_OBJECTS
where object_name = 'OBJECT_NAME';
```

```sql
select owner, object_name, object_type
from ALL_OBJECTS
where object_name = 'POSITION_DESCRIPTION';
```

```sql
select owner, object_name, object_type
from ALL_OBJECTS
where object_name = 'PD_INTERDIS';
```

## Grant
### Syntax for tables
```sql
GRANT privilege-type ON [TABLE] { table-Name | view-Name } TO grantees
```

### Example: Grant select to user FOO on table TABLE owned by schema SCHEMA
```sql
GRANT SELECT ON SCHEMA.TABLE TO FOO;
```
> NOTE: `GRANT SELECT ON TABLE SCHEMA.TABLE TO FOO;` would not work. 


## View privileges on a table
```sql
SELECT * FROM DBA_TAB_PRIVS;
WHERE TABLE_NAME = 'TABLE_NAME';
```

### Examples
```sql
SELECT PRIVILEGE
FROM DBA_TAB_PRIVS
WHERE TABLE_NAME = 'POSITION_DESCRIPTION'
AND OWNER = 'FS_HRM_PD'
AND GRANTEE = 'ANL_DASI_PROXY';
```

```sql
SELECT OWNER, TABLE_NAME, PRIVILEGE
FROM DBA_TAB_PRIVS
WHERE TABLE_NAME = 'PD_INTERDIS'
AND OWNER = 'FS_HRM_PD'
AND GRANTEE = 'ANL_DASI_PROXY';
```

## Running a script with SQL+
```bash
cat script.sql | sqlplus -s / as sysdba
```

## ORA-00257: Archiver error
[Instructions found here](https://virtual-dba.com/blog/troubleshoot-ora-00257-archiver-error/#:~:text=The%20ORA%2D00257%20error%20is,our%20archivelogs%20are%20being%20stored.)

The ORA-00257 error is a very common Oracle database error. The error is
basically trying to tell us that we have run out of logical or physical space on
our ASM diskgroup, mount, local disk, or db_recovery_file_dest location where
our archivelogs are being stored.

First, log into sql plus as sysdba and execute the following command to find out
if archive mode is enabled and where the files are being stored.

{{< code-show-user lang="sql" prompt="SQL>" output="2-10" >}}
archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     495227
Next log sequence to archive   495229
Current log sequence           495229
{{< /code-show-user >}}

{{< code-show-user lang="sql" prompt="SQL>" output="2-10" >}}
show parameter db_recovery_file

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest                string      /opt/oracle/oradata/fra01
db_recovery_file_dest_size           big integer 49G
{{< /code-show-user >}}


## Check database and listener processes
```shell
ps -fu oracle | egrep "[p]mon|[t]nslsnr"
```

## Start and shutdown database
Start
```shell
$ORACLE_HOME/bin/dbstart $ORACLE_HOME
```

Shutdown
```shell
$ORACLE_HOME/bin/dbshut $ORACLE_HOME
```

## Generate an html report
```sql
set markup html on
spool FILENAME.html
...
...
...
spool off
exit
```

## Make output more readable
```sql
set lin 5000
```

## Exporting a schema
Unlock the system account
```sql
alter user system identified by "&password";
alter user system account unlock;
exit
```

```shell
expdp system/manager schemas=user1 dumpfile=user1.dpdmp directory=DUMPDIR
```

By default, the exports go to `/fslink/orapriv/ora_exports`.

