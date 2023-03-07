+++
title = "SQL/Protect"
author = ["Clint Jordan"]
description = " "
date = "2023-03-06"
lastmod = " "
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

## Configuration

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


