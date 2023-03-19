+++
title = "EDB User Profile Management"
author = ["Clint Jordan"]
description = " "
date = 2023-02-28
lastmod = " "
tags = ["EDB"]
categories = ["notes"]
draft = false
+++


# User profiles (password attributes)

* A profile is a named set of password attributes
* User profiles can be used to manage account status and password expiration
* The `default` profile is assigned to all users

User profiles provide the following security features

| **Attribute**             | **Value** |
|-----------------------    |-----------|
| FAILED_LOGIN_ATTEMPTS     | UNLIMITED |
| PASSWORD_LOCK_TIME        | UNLIMITED |
| PASSWORD_LIFE_TIME        | UNLIMITED |
| PASSWORD_GRACE_TIME       | UNLIMITED |
| PASSWORD_REUSE_TIME       | UNLIMITED |
| PASSWORD_REUSE_MAX        | UNLIMITED |
| PASSWORD_GRACE_TIME       | UNLIMITED |
| PASSWORD_VERIFY_FUNCTION  | NULL      |


## View a user profile

```text
edb=# select * from dba_profiles
where profile='DEFAULT';

 profile |      resource_name       | resource_type |   limit   | common
---------+--------------------------+---------------+-----------+--------
 DEFAULT | FAILED_LOGIN_ATTEMPTS    | PASSWORD      | UNLIMITED | NO
 DEFAULT | PASSWORD_ALLOW_HASHED    | PASSWORD      | YES       | NO
 DEFAULT | PASSWORD_GRACE_TIME      | PASSWORD      | UNLIMITED | NO
 DEFAULT | PASSWORD_LIFE_TIME       | PASSWORD      | UNLIMITED | NO
 DEFAULT | PASSWORD_LOCK_TIME       | PASSWORD      | UNLIMITED | NO
 DEFAULT | PASSWORD_REUSE_MAX       | PASSWORD      | UNLIMITED | NO
 DEFAULT | PASSWORD_REUSE_TIME      | PASSWORD      | UNLIMITED | NO
 DEFAULT | PASSWORD_VERIFY_FUNCTION | PASSWORD      | NULL      | NO
(8 rows)
```
