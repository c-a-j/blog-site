+++
title = "Fix broken links in github build"
author = ["Clint Jordan"]
description = " "
date = 2023-03-15
lastmod = ""
tags = ["in-progress"]
categories = ["to-do"]
draft = true
autonumber = false
+++


## Fix broken links in github build
* this needs to be updated, add details on makefile
The home links are pointing to `https://code.fs.usda.gov/` rather than
`https://code.fs.usda.gov/pages/clint-jordan/site`. For now the fix is this...

```text
find . -type f -exec sed -i 's|href="/"|href="https://code.fs.usda.gov/pages/clint-jordan/site"|g' {} +
```

Also the links for images are broken in github. They point to
`https://code.fs.usda.gov/images/custom-putty.png` rather than
`https://code.fs.usda.gov/pages/clint-jordan/site/images/custom-putty.png`. For
now the fix is this...

```text
find . -type f -exec sed -i 's|src="/images/|src="/pages/clint-jordan/site/images/|g' {} +
```
