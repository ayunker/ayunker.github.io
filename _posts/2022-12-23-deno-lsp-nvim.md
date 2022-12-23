---
layout: post
title: deno, lsp, and nvim
date: 2022-12-23
---

I'm doing [Advent of Code][aoc] this year. I've already fallen behind, but do
plan to stick with it as long as I can, and hopefully get it completed 100%
before next year's iteration.

I waffled for a long time between doing Advent in ruby, my preferred and
most comfortable language (and one in which I haven't written much lately), and
typescript, a new language I picked up for work that is really exciting me with
all of it's statically typed goodness.

I ended up going with typescript, and also wanted to try out [deno][deno] as a
runtime instead of [node][node]. Mainly because deno seems simpler to setup and
configure than node, has first class support for typescript; plus, it's new(er).

At work I've gotten accustomed to having language server support with javascript
and node in the form of auto-completion, auto-formatting, linting and error
reporting in nvim. I wanted this same experience for Advent, but needed to
configure this for deno and wanted to use nvim's built-in LSP.

I've never setup an LSP before, with any editor or plugin, and never used deno
before. So while a lot of the instructions were in hindsight probably pretty
clear, it didn't totally all make sense to me on first read through. On the off
chance others feel the same way, maybe listing the steps here could help someone
else out.

* Install `deno`. On macOs - `brew install deno`.  This executable is not only
  the runtime, but also contains a linter (`deno lint`), formatter (`deno
  format`), and LSP (and other things). All of these commands can be run on
  their own via the CLI, but where's the fun in that?
* Install `neovim` - `brew install neovim`. I think you need > v0.5 for built in
  LSP support, but by this time whichever version you install should be well
  past that. At time of writing, I'm running v 0.8.1.
* Install the [`nvim-lspconfig`][nvim-lspconfig] plugin - I use
  [vim-plug][vim-plug], but any package manager will do. This...sets up basic
  configs for the various language servers to interface with nvim's LSP. I don't
  fully understand all of what this does, but my understanding is it's a wrapper
  around all the plumbing you don't want to worry about getting an LSP setup.
  I'm happy enough to use it and not need to dig any deeper.
* Turn on LSP support for deno. In either `init.lua` or a lua block in
  `init.vim` (what I do since I haven't converted all my vimscript to lua),
  enable via:
  ``` lua
  require'lspconfig'.denols.setup{}
  ```
  This gets you linting, and typescript errors in nvim. Pretty nifty. It does
  not however, get you formatting.
* Enable formatting on save. This isn't on out of the box, and probably for good
  reason as it will modify your files when it runs.  It's simple enough to turn
  on though. Using an `autocmd`, you can invoke the LSP formatter on save:
  ``` lua
  lua vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
  ```
  Now on every save, the formatter will kick in and pretty up your code.

The one thing missing here is auto-complete. As far as I know, this doesn't come
out of the box with nvim's LSP, and you need a separate plugin to hook that in.
I haven't done that yet, mostly because my files are small enough in Advent that
I'm not missing it too much, but it is something I want down the road. Just
didn't want to spend too much time yak-shaving rather than actually solving some
Advents.

<br/>

---

<br/>

At the end of the day, I think a minimal `init.vim` to setup LSP support with
deno would look something like this:

``` vimscript
call plug#begin(stdpath('data') . '/plugged')

Plug 'neovim/nvim-lspconfig'

call plug#end()

lua << EOF
require'lspconfig'.denols.setup{}
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
EOF
```

And you'd get something that looks like this:

[![](/assets/images/deno-lsp-nvim-1.jpg)](/assets/images/deno-lsp-nvim-1.jpg){:target="_blank"}

[aoc]: https://adventofcode.com/
[deno]: https://deno.land/
[node]: https://nodejs.org/
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[vim-plug]: https://github.com/junegunn/vim-plug

[lsp-image]: /assets/images/deno-lsp-nvim-1.jpg
