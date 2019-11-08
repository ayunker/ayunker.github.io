---
layout: post
title: sublime code folding shortcuts
date: 2019-11-08
categories: sublime_text 
---

I haven't been much of a code folder, at least not since starting to write
ruby. Idiomatic ruby encourages small files and methods, so often code folding
doesn't make all that much of a difference. However, now I'm getting into some
code in larger files and longer methods. The goal is to refactor this down into
more manageable chunks, but I still need to be able to reason with the code
as-is until that happens. I've found code folding to be helpful in seeing the
messages these classes can send, and only worry about the implementation when
needed.

The issue I have is I don't like the default fold/unfold shortcuts in
SublimeText. `Command + Option + [` to fold and `Command + Option + ]` to unfold
forces me to twist my fingers in yet another configuration, and a missed key can
lead to changing the indentation of the line instead of folding the block.

Instead, I've decided to remap fold to `Command + K, [`, and unfold to `Command
+ K, ]`. I kind of stole inspiration from the vim 'leader' key, where `Command +
  K` is the leader, and indicates whatever comes after is a command.

The leader key is one of many concepts in vim that I like, but I'm not ready to
make the jump to full on vim yet. But incorporating some vim-esque things I like
into Sublime - that's something I can do.

Here's the relevant code snippet, and you can see all my [Sublime keybindings
here][keybindings_gh]

``` json
{
  ...
  { "keys": ["command+k", "["], "command": "fold" },
  { "keys": ["command+k", "]"], "command": "unfold"},
  ...
}
```

[keybindings_gh]: https://github.com/ayunker/dotfiles/blob/master/sublime/Default%20(OSX).sublime-keymap
