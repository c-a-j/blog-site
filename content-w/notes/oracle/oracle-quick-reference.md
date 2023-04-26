+++
title = "Oracle Quick Reference"
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
