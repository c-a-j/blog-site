+++
title = "Meta commands"
author = ["Clint Jordan"]
description = " "
date = "2023-03-06"
lastmod = " "
tags = ["edb"]
categories = ["notes"]
draft = false
+++

## Information commands

```text
\d(i, s, t, v, b, S)[+] [pattern]
```

* lists information about indexes, sequences, tables, views, tablespaces or
system objects. Any combination of letters may be used in any order, for example
`\dvs`
* `+` displays comments

```text
\d[+] [pattern]
```

* for each relation describe/display the relation structure details
* `+` displays any comments associated with the columns of the table, and if the
table has an OID column
* without a pattern, `\d[+]` is equivalent to `\dtvs[+]`


```text
\l [+]
```
* list the names, owners, and character set encodings of all the databases in
the server
* if +  is appended to the command name, database descriptions are also
displayed

```text
\dn+ [pattern]
```
* lists schemas (namespaces)
* `+` adds permissions and description to output

```text
\df+ [pattern]
```
* lists functions 
* `+` adds owner, language, source code, and description to output


## Other common meta commands

```text
\conninfo
```
* display current connection information

```text
\q or ^d or quit or exit
```
* quits the edb-psql program

```text
\cd [directory]
```
* changes the current working directory

```text
\! [command]
```
* executes the specified system command
* if no command is specified, escapes to a separate Unix shell
* ex: print current working directory, `\! pwd`


## Help commands

```text
\?
```
* display list of all meta commands

```text
\h [command]
```
* shows information about SQL commands
* if command isn't specified, lists all SQL commands

```text
edb-psql --help
```
* lists command line options for edb-psql
