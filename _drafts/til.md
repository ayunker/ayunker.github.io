---
layout: post
title: til
date: 2023-03-14
---

I've been writing [TILs][my_tils] for almost two years. I've grown a small
collection, but it's a nice place to keep short-form things I've learned.

I think I first heard about TILs from [Hashrocket][hr_tils], where I now work.
The style of mine is ~~borrowed~~ stolen from former rocketeer [Josh
Branchaud][jbranchaud_tils] - it's simple but it works for me. Text files get the
job done here, no need for a database.

Most of my TILs now first get posted to to Hashrocket's [TIL][hr_tils], but I'll
also post them here for my own records.

There are a few steps to creating a TIL, so to make things more streamlined I
wrote a [script][til_script]. It's in my `/bin` directory so creating a TIL is
just a `tiller` away. It takes a subject (ruby, vim, etc), and the title; and
then creates the file for the TIL, adds a link to the new TIL in the `README`,
and opens the TIL in vim. Then all I need to do is write the thing, move the
link in the README to the appropriate section (I can probably automate
this...but for now beyond the scope of MVP 😅), commit and push. No more faffing
about creating and opening files, `tiller` does that all for me.

This is part of an effort to better automate things that I repeatedly do -
either with a script or Makefile, or something else.

In the future, I'm debating making a static site to host these. They're all
markdown files, so in theory it shouldn't be too much work. Just something
simple to click around and browse, with a bit more eye candy than a Github repo.
Might be a good reason to give [lume][lume] a shot 🤔.



[my_tils]: https://github.com/ayunker/til
[hr_tils]: https://til.hashrocket.com/
[jbranchaud_tils]: https://github.com/jbranchaud/til
[til_script]: https://github.com/ayunker/dotfiles/blob/master/bin/tiller
[lume]: https://lume.land/
