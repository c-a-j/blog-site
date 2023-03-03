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
start up costs to develop solid templates. 

* Advantages for leadership: 
    * increased documentation readability
    * speed of documentation development
    * totally transparent version control
* Advantages for developers
    * increase simplicity of the documentation process
    * increase speed of the documentation process
    * elimination of menial and repetetive formatting tasks
    * opportunity to use a version control process that essentially the entire
        tech sector adopted nearly 20 years ago
* Advantages for operators:
    * increased clarity in documentation
    * confidence in version control
    * nice little perks like click-to-copy code blocks

### $\LaTeX$
Sure, latex has the potential to look just as complicated as C++, but with
a good template it can become reasonably close to plain text. No matter how much
time you spend fixing Word's formatting (over and over and over again), it still
can't match the superior typsetting of latex even after 40 years of
developement.

With that being said, there is one disadvantage with latex, it must be compiled.
However, with a solid template this should only need to be done a few times.
The end result of the compilation is a nice PDF that can't accidentally be
modified by operators (I can still hardly believe we distribute Word files for
that reason alone).

### Markdown
In my opinion, markdown is the option best suited for our needs. We could get
close to plain text with a latex template, but markdown essentially *is* plain
text. And since developers use github enterprise (code.fs) to store their code
already, it just makes sense for them also store the documentation there using
git.  There's a good reason that essentially the ***entire tech sector*** does
this.  It's convenient and it looks really nice.  Take for example the following
screenshot from a release notice written in MS Word.

{{< rawhtml >}}
<img src="/images/word_rn.png" width="100">
{{< /rawhtml >}}

The only thing separating instructional text and command input/output is
a slight change in font. Additionally, different developers have different
subtle styles of doing things, which can make some of these RNs hard to read and
easy to get lost in. On the other hand, markdown makes documentation drastically
clear.

...

## The ability to find things

Ahh, it's one of the most rudimentary capabilities that

## Version control like Linus intended

