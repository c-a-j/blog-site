+++
title = "SQL/Protect STIG Scanner"
author = ["Clint Jordan"]
description = " "
date = "2023-04-18"
lastmod = ""
tags = ["STIG", "sql protect", "edb"]
categories = ["notes"]
draft = false
autonumber = false
printmode = false
+++


## Run Queries from Command Line
```text
psql -U username -d mydatabase -c 'SELECT * FROM mytable'
```

## View Protected Users
```text
SELECT * FROM sqlprotect.list_protected_users;
```

## View SQL/Protect Status

### Ensure installation
```text
show shared_preload_libraries;
```

### Ensure that SQL/Protect is enabled
```text
show edb_sql_protect.enabled;
```

### Check the mode
```text
show edb_sql_protect.level;
```
