+++
title = "RMAN"
author = ["Clint Jordan"]
description = " "
date = "2023-04-24"
lastmod = ""
tags = ["oracle", "RMAN"]
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
