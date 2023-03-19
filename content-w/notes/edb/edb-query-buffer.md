+++
title = "History, query buffer, and output control"
author = ["Clint Jordan"]
description = " "
date = "2023-03-06"
lastmod = ""
tags = ["edb"]
categories = ["notes"]
draft = false
+++


Show the command history.

```text
\s
```

Save the command history to a file, `FILENAME`.

```text
\s FILENAME
```

Edit the query buffer and then execute it.

```text
\e 
```

Open the query buffer in a file, `FILENAME`, and execute it upon save.

```text
\e FILENAME
```

Save the query buffer to a file, `FILENAME`.

```text
\w FILENAME
```

Direct the output of the next command to file, `FILENAME`.

```text
\o FILENAME
```

Execute the query buffer and send output to file, `FILENAME`.

```text
\g
```

Run previous query repeatedly.

```text
\watch <seconds>
```
