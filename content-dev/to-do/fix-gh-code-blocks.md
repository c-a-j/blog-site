+++
title = "Fix code blocks"
author = ["Clint Jordan"]
description = " "
date = 2023-04-03
lastmod = ""
tags = ["not started"]
categories = ["to-do"]
draft = true
autonumber = false
+++

## Issue(s)
* custom command line code blocks are not rendering correctly on code.fs


## Solutions(s)
* turned out to be the links to `prism.js` and `prism.css`

Added the following lines to the makefile

```text
find ~/hugo/site -type f -exec sed -i 's|href="/css/prism.css|href="/pages/clint-jordan/css/prism.css/|g' {} +
find ~/hugo/site -type f -exec sed -i 's|src="/js/prism.js|src="/pages/clint-jordan/js/prism.js/|g' {} +
```
