+++
title = "To-do items"
author = ["Clint Jordan"]
description = " "
date = 2020-01-01
lastmod = "2023-03-07"
tags = ["to-do"]
categories = ["notes"]
draft = true
autonumber = true
+++


## Get rid of "link to text" feature
* got it, but there's still leftover junk
    * commented lined 2113-2132 in `assets/css/refined.css`
* grep fragmentions

## Change second and third level bullet characters
* first bullet solid circle
* second bullet hollow
* third bullet dash

## Change header before characters and link characters
* `assets/css/refined.css`, lines 821 - 836
* find a way to enable automatic header numbering for h2, h3, h4, and h5 
    * **not** globally, though

## Find a way to enable automatic header numbering for h2, h3, h4, and h5 
* **not** globally
* getting close
* created `static/css/autonumber.css` to override default settings with
     `autonumber = true` in font matter
* most header settings are in `assets/css/refined.css` from 744-on
* now need to find a way to make numbers appear in navbar on the right

## Change font size of h4 and h5
### h3
#### h4
##### h5
Regular text is larger than h5. Should be equal or larger.

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

## Fix broken links in github build
* temporary solution in the archives
* this is remaining bc process still needs improvement

## Clean up `/notes/edb-schemas.md`
* code blocks should be placed below description
* incorporate `code-show-user` shortcode

## Impliment alert, warning, etc shortcodes
> These are taken from the docsy template.
{{< alert >}}This is an alert.{{< /alert >}}
{{< warning >}}This is a warning.{{< /warning >}}


