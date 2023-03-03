+++
title = "EDB create database"
author = ["Clint Jordan"]
description = " "
date = "2023-03-02"
lastmod = "2023-03-02"
tags = ["EDB"]
categories = ["notes"]
draft = false
+++

```text
CREATE DATABASE db;
```

Creates a database called db.


```text
REVOKE CONNECT ON database FROM public;
```

This revokes connect privilege from everyone excluding the owner and
superuser(s).

```text
GRANT CONNECT ON DATABASE db TO user1, user3;
```

Grants connect privilege to user1 and user3;

