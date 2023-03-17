+++
title = "Site title adjustment"
author = ["Clint Jordan"]
description = " "
date = 2023-03-17
lastmod = ""
tags = ["complete"]
categories = ["to-do"]
draft = true
autonumber = false
+++

## Issue
The site title is configured to be the same color as the body text. These colors
need to be decoupled.


## Solution
* added `--theme-site-title-color` to `layouts/partials/head.html`
* added `site_title_color` to `data/theme.toml`
* added `color: var(--theme-site-title-color)` to line 1150 in
    `assets/css/refined.css`
