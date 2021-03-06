---
layout: post
title: running rspec from vim
date: 2020-10-21
---

I started using vim over the summer, and it's become my go to text editor.
There's probably a longer blog post to write about that transition, but that'll
take some time to write up. This is just a short bit about running tests.

One soft spot in my workflow was running tests quickly and efficiently. When I
first started using vim, I would write the test code, save in vim (`:w`),
change to the iTerm split below (`cmd + ]`), hit up to rerun the test; then
`cmd + ]` to get back to vim. For someone like me, who does some form of TDD,
this is a lot of overhead, especially when I run tests as frequently as
multiple times per minute.

Conveniently, this is a problem that many people have already run into, and
there are multiple solutions out there. Since I'm mostly writing ruby these
days, I went with the [vim-rspec](https://github.com/thoughtbot/vim-rspec)
plugin by thoughtbot. The setup is straightforward, but for someone new to vim
like me it was a little confusing how to set it up to get it working with
[Zeus](https://github.com/burke/zeus).

vim-rspec can be installed by whichever method you prefer, I use
[vim-plug](https://github.com/junegunn/vim-plug). Once installed, you can set
some mappings in your `.vimrc`, I stuck with the standard ones recommended in
the README. I don't want to run the entire test suite from inside vim, so I
omitted that mapping. If I want to run more than a single spec file at a time,
I do that in a separate terminal pane/window/instance.

``` vim
" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
```

This setup uses the regular `rspec` command; which depending on how big your
rails app is can take a while to start up. For me, this is about 8-10 seconds
before a test can even run. I alleviated this previously by using
[Zeus](https://github.com/burke/zeus). I needed to figure out how to get
`vim-rspec` to use Zeus too.

There is a section in the `vim-rspec` README on how to override the rspec
command with a custom command, following that and replacing with zeus, I ended
up with:
``` vim
let g:rspec_command = "!zeus rspec {spec}"
```

Now, I can write some code, save it, and without leaving vim type `<space> t`
or `<space> s` and get the results back in seconds. Hit any key again, and I'm
right back in vim ready to go. Pure bliss.

There are ways to level this up even further, I know. Eventually the workflow
may evolve into sending the `rspec` command to a different tmux pane, so I can
see results side by side with vim. But for now, this is good enough for me.
