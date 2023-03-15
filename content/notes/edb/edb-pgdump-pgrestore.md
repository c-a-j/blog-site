+++
title = "pg_dump and pg_restore"
author = ["Clint Jordan"]
description = " "
date = "2023-03-06"
lastmod = "2023-03-14"
tags = ["edb","sql protect"]
categories = ["notes"]
draft = false
+++

## Exporting a schema
```text
pg_dump -p 5443 -d db01d -Fp -n sqlprotect -f sqlprotect.dmp
```

## Restoring a schema
```text
psql -p 5444 -d db01p -f sqlprotect.dmp
```
