+++
title = "Why I created this site for work"
author = ["Clint Jordan"]
description = " "
date = 2023-02-27
lastmod = ''
categories = ["post"]
draft = true
+++


{{< rawhtml >}}
<script type="text/javascript"
  src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS_CHTML">
</script>
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [['$','$'], ['\\(','\\)']],
      processEscapes: true},
      jax: ["input/TeX","input/MathML","input/AsciiMath","output/CommonHTML"],
      extensions:
["tex2jax.js","mml2jax.js","asciimath2jax.js","MathMenu.js","MathZoom.js","AssistiveMML.js",
"[Contrib]/a11y/accessibility-menu.js"],
      TeX: {
      extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"],
      equationNumbers: {
      autoNumber: "AMS"
      }
    }
  });
</script>
{{< /rawhtml >}}

## Why invest time into a site like this

There are several main reasons I prefer to use a site like this to store my notes
and documentation.

1. Microsoft Word is awful
2. Vim is great
3. The asthetics are ***much*** better
4. This content can be searched
5. Version control

And when it comes down to it, the preference really boils down to just one
reason.

1. Microsoft Word is awful

So, one by one, I'll go into a little detail on each of these reasons. 

## Why MS Word is awful

To be honest, it's not just Word, I actually find almost the entire MS Office
suite overly cumbersome, but Word holds a special place in my heart as my least
favorite piece of it. While it is the de facto standard in many industries, tech
and academia are a few of the areas that it does *not* shine. If you've ever
written a technical document with a lot of citations, figures, equations,
tables, code blocks, and strict formatting rules, you're probably well aware of
the many headaches that Word can cause. When using Word for anything more
complex than an essay, there is a constant hassle to maintain formatting, which
is not only frustrating, but can become a wasteful time sink over long periods.

I was able to navigate nearly my entire college career without ever using Word.
That might be surprising to some, but it is quite common in engineering an
computer science, especially at higher levels. After I started using Vim and
[$\LaTeX$](https://www.latex-project.org/) early in my second year, there was no
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
with the superior typesetting and templating capabilities of $\LaTeX$ makes
using MS Word seem like swimming in honey.

However, there are lots of people in tech that prefer not to completely ditch
the mouse. Notepad++ is a good option available with a low-angle learning curve
when compared to Vim. With that being said, Vim is the standard editor on all of
our servers, so there's a good reason to become proficient. Just imagine how
proficient *everyone* would be if *all* our documentation was written in plain
text... 

## The superiority of markdown and $\LaTeX$

Both of these options would provide advantages over Word with just a little
start up costs to develop solid templates. Everyone would stand to gain.

* Leadership gets readability, speed of development, and totally transparent
    version control
* Developers get simplicity, speed of develpement, and version control that
    essentially the entire tech sector adopted almost 20 years ago
* Operators get increased clarity, confidence in version control, and other
    nice perks like click-to-copy code blocks

### $\LaTeX$
Sure, latex has the potential to look just as complicated as C++, but with
a good template it can become reasonably close to plain text. Armed with a text
editor and template, developers would be free to focus on the material 

### Markdown
Markdown is the option best suited for our needs, in my opinion. 

## The ability to find things

Ahh, it's one of the most rudimentary capabilities that

## Version control like Linus intended
