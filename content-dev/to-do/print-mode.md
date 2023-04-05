+++
title = "Add print mode"
author = ["Clint Jordan"]
description = " "
date = 2023-03-20
lastmod = ""
tags = ["in progress"]
categories = ["to-do"]
draft = true
autonumber = false
printmode = true
+++

## Issue(s)
* when printing to PDF, the header, footer, navbar, buttons, etc must manually
    be removed
* html files don't render correctly as stand alone files, need export solution

## Idea(s)
* add print mode variable to front matter
* add conditionals to all items that need to be removed for stand alone html
    file

## Solutions(s)
* use `monolith` to create stand alone html files
* it would still be nice to have a print mode in the fron matter, but monolith
    solves most the issues

### Install monolith
Install the Rust package manager, `cargo`

```text
sudo apt install cargo
```

Install monolith

```text
cargo install monolith
```

Append to `.bash_profile`

```text
export PATH=$PATH:"$HOME/.cargo/bin"
```

### Print mode
* added conditionals to `/layouts/_default/single.html`
    - removed footer, tags, and top/bottom buttons
* added conditional to `/layouts/partials/navbar.html`
    - removed top navbar
* added conditional to `/layouts/_default/_baseof.html`
    - site title link to nowhere

