+++
title = "Change list characters"
author = ["Clint Jordan"]
description = " "
date = 2023-03-15
lastmod = ""
tags = ["complete"]
categories = ["to-do"]
draft = true
autonumber = false
+++


## Change second and third level bullet characters
* first bullet solid circle
    * second bullet hollow
        * third bullet dash
        * third bullet dash
        * third bullet dash
        * third bullet dash
    * second bullet hollow
* first bullet solid circle
* first bullet solid circle


## Solution
* modified lines 1054-1079 in `assets/css/refined.css`
* grep `li::before`
