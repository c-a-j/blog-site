+++
title = "Adjust header style"
author = ["Clint Jordan"]
description = " "
date = 2023-03-15
lastmod = ""
tags = ["complete"]
categories = ["to-do"]
draft = true
autonumber = false
+++


# h1
## h2
### h3
#### h4
##### h5
###### h6 this is h6

Issues
* regular text is larger than h5. Should be equal or larger.
* header color is the same as links, should probably be a shade of grey/white
* not a big fan of the asterisks, look into alternatives


Solutions
* Changed header color
    * `heading_color = "#d4d5d6"` in `data/theme.toml`
* Changed body font color
    * `body_color = "#c1c3c5"` in `data/theme.toml`
* Changed header sizes on lines 643-662 in `assets/css/refined.css`

