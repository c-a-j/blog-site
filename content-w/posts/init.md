+++
title = "Why I created this site for work"
author = ["Clint Jordan"]
description = " "
date = 2023-02-27
lastmod = ''
categories = ["post"]
draft = true
+++

## Why invest time into a site like this

There are several main reasons I prefer to use a site like this to store my notes
and documentation.

1. Microsoft Word is awful
2. Vim is great
3. The aesthetics are ***much*** better
4. Easily searchable content
5. Version control

And when it comes down to it, the preference really boils down to just one
reason.

1. Microsoft Word is awful

## Why MS Word is awful
To be honest, it's not just Word, I actually find almost the entire MS Office
suite overly cumbersome, but Word holds a special place in my heart as my least
favorite piece of it. While it is the de facto standard in many industries, tech
and academia are a few of the areas that it objectively does *not* shine. If
you've ever written a technical document with a lot of citations, figures,
equations, tables, code blocks, dynamic content, and strict formatting rules,
you're probably well aware of the many headaches that Word can cause. When using
Word for anything more complex than an essay, there is a constant hassle to
maintain formatting, which is frustrating and becomes a wasteful time sink
over long periods. And, really, how beneficial is spending time becoming "good"
at navigating endless GUI menus that will probably be reorganized in future
releases? 

I was able to navigate nearly my entire college career without ever using Word.
That might be surprising to some, but it is quite common in engineering and
computer science, especially at higher levels. After I started using Vim and
[LaTeX](https://www.latex-project.org/) early in my second year, there was no
looking back. The efficiency I gained rendered MS Word utterly useless to me.

## Why Vim is awsome
Vim is a highly efficient text editor released in 1991 that allows users to
perform complex text manipulation tasks with minimal effort. It's editing system
allows users to switch between different modes that enable them to navigate,
edit, and manipulate text with speed and precision. With Vim, users can quickly
move the cursor to any point in the text, search and replace, perform batch
edits, and run custom macros and scripts. Vim's extensive keyboard shortcuts and
commands eliminate the need to navigate through graphical menus or use a mouse
or trackpad, making it much faster and more efficient than Microsoft Word for
users who are comfortable with its interface. Its powerful features combined
with the superior typesetting and templating capabilities of LaTeX makes
using MS Word seem like swimming in honey.

However, there are lots of people in tech that prefer not to completely ditch
the mouse. Notepad++ is a good option available with a low-angle learning curve
when compared to Vim. With that being said, Vim is the standard editor on all of
our servers, so there's a good reason to become proficient. Just imagine how
proficient *everyone* would be if *all* our documentation was written in plain
text... 

## The superiority of markdown and/or LaTeX
Both of these options would provide advantages over Word with just a little
start up costs to develop solid templates. 

* Advantages for leadership: 
    * increased documentation readability
    * speed of documentation development
    * totally transparent version control
* Advantages for developers
    * increase simplicity of the documentation process
    * increase speed of the documentation process
    * elimination of menial and repetitive formatting tasks
    * opportunity to use a version control process that essentially the entire
        tech sector adopted nearly 20 years ago
* Advantages for operators:
    * increased clarity in documentation
    * confidence in version control
    * nifty perks like click-to-copy code blocks

### LaTeX
Sure, latex has the potential to look just as complicated as C++, but with
a good template it can become reasonably close to plain text. No matter how much
time you spend fixing Word's formatting (over and over and over again), it still
can't match the superior typesetting of latex even after 40 years of
development.

With that being said, there are a few disadvantages with latex. The biggest
downside is probably that it must be compiled. However, with a solid template
this should only need to be done a few times. The end result of the compilation
is a nice PDF that can't accidentally be modified by operators. Another
disadvantage is that copy/paste operations from PFDs can be generally
unreliable.

### Markdown
In my opinion, markdown is the option best suited for our needs. We could get
close to plain text with a latex template, but markdown essentially *is* plain
text. That means almost no training is required. And since developers use github
enterprise (code.fs) to store their code already, it just makes sense for them
also store the documentation there using `git`.  There's a good reason that
essentially the ***entire tech sector*** does this.  It's convenient and it
looks really nice. 

There are many options for creating markdown documentation ranging in complexity
from simple GitHub README files to entire webpages using static site generators.

Potential tools:

* [Pandoc](https://pandoc.org/)
    * document converter
    * generate stand-alone html files from template
* [Hugo](https://gohugo.io/)
    * static site generator
    * this site was created with Hugo
* [11ty](https://www.11ty.dev/)
    * static site generator
* [monolith](https://crates.io/crates/monolith)
    * generate stand-alone html files from any webpage

If interested, ask me how I created this site with Hugo and generate stand-alone
documents with monolith. 
