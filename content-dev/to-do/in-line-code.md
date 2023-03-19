+++
title = "Set in-line code highlight color"
author = ["Clint Jordan"]
description = " "
date = 2023-03-15
lastmod = ""
tags = ["complete"]
categories = ["to-do"]
draft = true
autonumber = false
+++

## issues
* in-line code color not highlighted

## solutions
* added `--theme-inline-code-bg-color` to `layouts/partials/head.html`
* added `inline_code_bg_color = "#24282c"` to `data/theme.toml` 
* added `background-color: var(--theme-inline-code-bg-color);` to line 1406 in `assets/css/refined.css`

