+++
title = "SQL Primer"
author = ["Clint Jordan"]
description = " "
date = "2023-03-07"
lastmod = ""
tags = ["edb", "sql"]
categories = ["notes"]
draft = false
+++


## Data types

| **Numeric Types** | **Character Types**   | **Date/Time Types**   | **Other Types**   | **Advanced Server**   |
|-------------------|---------------------  |---------------------  |-----------------  |---------------------- |
| NUMERIC           | CHAR                  | TIMESTAMP             | BYTEA             | CLOB                  |
| INTEGER           | VARCHAR               | DATE                  | BOOL              | BLOB                  |
| SERIAL            | TEXT                  | TIME                  | MONEY             | VARCHAR2              |  
|                   |                       | INTERVAL              | XML               | NUMBER                | 
|                   |                       |                       | JSON              | XMLTYPE               |
|                   |                       |                       | JSONB             |                       |


List all data types.

```text
\dT *
```

## Structured Query Language

| **Data Definition Language**  | **Data Manipulation Language**    | **Data Control Language** | **Transaction Control Language**  |
|-------------------            |---------------------              |---------------------      |-----------------                  |
| CREATE                        | INSERT                            | GRANT                     | COMMIT                            |
| ALTER                         | UPDATE                            | REVOKE                    | ROLLBACK                          |
| DROP                          | DELETE                            |                           | SAVEPOINT                         |
| TRUNCATE                      |                                   |                           | SET                               |
|                               |                                   |                           | TRANSACTION                       |



