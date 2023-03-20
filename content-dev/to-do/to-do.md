+++
title = "Prism code blocks"
author = ["Clint Jordan"]
description = " "
date = 2023-03-20
lastmod = ""
tags = ["not started"]
categories = ["to-do"]
draft = true
autonumber = false
+++

## Implement Prism code blocks (maybe)
* kind of got it, didn't get it to a place that was better than chroma
* also didn't find out exactly where to link the css and html
* may be easier to implement a click-to-copy for chroma
* took `code-no-copy.html` shortcode from other website

```html
<!DOCTYPE html>
  <html>
  <head>
     <link href="/css/prism.css" rel="stylesheet" />
  </head>
  <body>

     <script src="/js/prism.js"></script>
  </body>
  </html>
```
* placed `<script src="/js/prism.js"></script>` in `/layouts/_default/baseof.html`
* placed `<link href="/css/prism.css" rel="stylesheet">` in `/layouts/partials/head.html`
* works!

### Language display needs fix
* temporarily disabled display of language in code blocks
    * commented lines 1502-1514 and 1519-1614 in `/assets/css/refined.css`
    * issues
        * positioned behind copy button
        * breaks when using shortcodes
    * possible solutions
        * find way to enable this inside prism shortcodes
        * need to reposition copy button or simply live without it
