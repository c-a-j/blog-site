+++
title = "Code Blocks"
author = ["Clint Jordan"]
description = " "
date = 2023-03-15
lastmod = " "
tags = ["code blocks"]
categories = ["examples"]
draft = true
+++

## Code Blocks
### Blocks with continuation characters
{{< code-show-user lang="shell" prompt="[oracle] $" output="3,7,10">}}
export MY_VAR=123
echo "hello"
hello
echo one \
two \
three
one two three

echo "goodbye"
goodbye
{{< /code-show-user >}}
