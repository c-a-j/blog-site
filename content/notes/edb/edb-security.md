+++
title = "EPAS Security"
author = ["Clint Jordan"]
description = " "
date = "2023-03-06"
lastmod = " "
tags = ["edb"]
categories = ["notes"]
draft = false
+++

## Access control - pg_hba.conf

* host based access control file
* located in the cluster data directory
* read at startup, any change required reload
* contain set of records, one per line
* search record specifies connection type, database name, user name, client IP
and method of authentication;
* top to bottom read
* hostnames, IPv6 and IPv4 supported
* authentication methods, trust, reject, md5, password, gss, sspi, krb5, ident,
peer, pam, ldap, radius, bsd, scram or cert

## Row Level Security (RLS)
* GRANT and REVOKE can be used at table level
* PostgreSQL supports security policies for limiting access at row level
* by default, all rows of a table are visible
* once RLS is enabled on a table, all queries must go through the security
policy
* security policies are controlled by DBA rather than application
* RLS offers stronger security as it is enforced by the database

Example:

```sql
CREATE TABLE accounts (manager text, company text, contact_email text);

ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
```

To create a policy on the accounts table to allow the managers role to view the
rows of their accounts, the `CREATE POLICY` command can be used:
```sql
CREATE POLICY account_managers ON accounts TO managers USING
(manager = current_user);
```

To allow all users to view their own row in a user table, a simple policy can be
used:
```sql
CREATE POLICY user_policy ON users USING (user = current_user);
```

## Application access
* application acces is controlled by settings in both `postgresql.conf` and
`pg_hba.conf`.
* set the following parameters in `postgresql.conf`:
    - listen_addresses
    - max_connections
    - superuser_reserved_connections
    - port

## Data redaction
* data redaction can be used to conceal data values from selected users
* the redaction function is incorporated into redaction policy using `CREATE
REDACTION POLICY`.
* data redaction is controlled by `edb_data_redaction` configuration parameter
* useful for compliance to GDPR, PCI, and HIPAA standards

