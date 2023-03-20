+++
title = "Backup, recovery, and PITR"
author = ["Clint Jordan"]
description = ""
date = "2023-03-20"
lastmod = ""
tags = ["template"]
categories = ["notes"]
draft = false
autonumber = false
+++

## Logical Backups
### `pg_dump`
* database level SQL dump
    - does not backup users or tablespaces
* does not block readers or writers
* does not operate with special permissions

{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
pg_dump [options] [dbname]
{{< /code-show-user >}}

List options.

{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
pg_dump --help
{{< /code-show-user >}}

### `pg_dumpall`
* cluster level SQL dump

## Physical Backups
Copy using OS commands
* offline file system level backup

Low Level API or `pg_basebackup`
* online file system level backup

`pg_basebackup`
* uses replication technique to copy onto a media while server is in use
* automatically puts server in backup mode before backup and turns it off
    after backup

