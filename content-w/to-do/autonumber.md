+++
title = "Autonumbering"
author = ["Clint Jordan"]
description = " "
date = 2023-03-15
lastmod = ""
tags = ["in-progress"]
categories = ["to-do"]
draft = true
autonumber = true
+++

Find a way to enable automatic header numbering for h2, h3, h4, and h5 
* **not** globally
* created `static/css/autonumber.css` to override default settings with
     `autonumber = true` in font matter
* most header settings are in `assets/css/refined.css` from 744-on

## h2
### h3
#### h4
##### h5
###### h6

Issues
* numbering doesn't appear in navbar
* need method to disable for appendices
* need more space between numbers and periods

Solutions
* adjusted number spacing in `static/css/autonumber.css`
