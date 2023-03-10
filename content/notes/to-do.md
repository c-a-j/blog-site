+++
title = "To-do items"
author = ["Clint Jordan"]
description = " "
date = 2020-01-01
lastmod = "2023-03-07"
tags = ["to-do"]
categories = ["notes"]
draft = true
+++

* Get rid of "link to text" feature
    * got it, but there's still leftover junk
    * grep fragmentions
* Implement Prism code blocks (maybe)
    * kind of got it, didn't get it to a place that was better than chroma
    * also didn't find out exactly where to link the css and html
    * may be easier to implement a click-to-copy for chroma
* Update footer
* Change second and third level bullet characters
* set in-line code highlight color
    * done
* change h2 characters and links
    * `assets/css/refined.css`, lines 821 - 836

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

## Fix broken links in github build

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

