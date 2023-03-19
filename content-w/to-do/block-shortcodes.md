+++
title = "Implement additional block quote shortcodes"
author = ["Clint Jordan"]
description = " "
date = 2023-03-15
lastmod = ""
tags = ["complete"]
categories = ["to-do"]
draft = true
autonumber = false
+++

## Implement alert, warning, etc shortcodes
> This is a block quote 

{{< alert >}}
This is an alert. <br>
This is an alert. <br>
This is an alert. <br>
This is an alert. <br>
{{< /alert >}}

{{< warning >}}
This is a warning. <br>
This is a warning. <br>
This is a warning. <br>
This is a warning. <br>
{{< /warning >}}


## Solution 
* added `blockquote.alert` and `blockquote.warning` to `assets/css/refined.css`
* added `alert_color` and `warning_color` to `data/theme.toml`
* added `--theme-alert-color` and `--theme-warning-color` to `layouts/partials/head.html`
* created `layouts/shortcodes/alert.html` and `layouts/shortcodes/warning.html`
