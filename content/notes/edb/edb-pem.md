+++
title = "EDB Postgres Enterprise Manager"
author = ["Clint Jordan"]
description = " "
date = 2018-05-02
lastmod = ""
tags = ["EDB", "PEM"]
categories = ["notes"]
draft = false
+++


# Common connection problems

* Could not connect to Server - Connection refused
    - This error occurs when either the database server isn't running or the
      server isn't configured to accept external TCP/IP connections
* FATAL - no ph_hba.conf entry
    - This means your server can be contacted over the network, but is not
configured to accept the connection. Your client is not detected as a legal user
for the database:wq

