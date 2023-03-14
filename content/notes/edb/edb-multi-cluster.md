+++
title = "Multi Cluster Server"
author = ["Clint Jordan"]
description = " "
date = "2023-03-13"
lastmod = " "
tags = ["edb"]
categories = ["notes"]
draft = false
+++

## Create the clusters

{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
initdb -D /path/to/datadb1
initdb -D /path/to/datadb2
{{< /code-show-user >}}


## Start/stop the instances
Start
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
pg_ctl -D /path/to/datadb1 -o "-p 5444" -l /path/to/logdb1 start
pg_ctl -D /path/to/datadb2 -o "-p 5443" -l /path/to/logdb2 start
{{< /code-show-user >}}

Stop
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
pg_ctl -D /path/to/datadb1 -o "-p 5444" -l /path/to/logdb1 stop
pg_ctl -D /path/to/datadb2 -o "-p 5443" -l /path/to/logdb2 stop
{{< /code-show-user >}}

## Connect to a cluster
{{< code-show-user lang="shell" prompt="enterprisedb $" output="" cont-str="" cont-prompt=">" >}}
psql "port=5444"
{{< /code-show-user >}}

