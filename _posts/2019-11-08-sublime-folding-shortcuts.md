---
layout: post
title: sublime code folding shortcuts
date: 2019-12-07
categories: sublime_text 
---

I haven't been much of a code folder, at least not since starting to write
ruby. Idiomatic ruby encourages small files and methods, so often code folding
doesn't make all that much of a difference.

However, lately I've been looking at a lot of code that I didn't write; and
trying to understand the flow of the code. To to this, I've been looking just
at the method calls, and not worrying at all about the implementation. Code
folding hides all those pesky details, so I can't get distracted by what's
inside and can instead focus on the messages the classes are sending.

The issue I have is I don't like the default fold/unfold shortcuts in
SublimeText. `Command + Option + [` to fold and `Command + Option + ]` to
unfold forces me to twist my fingers in yet another configuration, and a missed
key can lead to changing the indentation of the line instead of folding the
block.

Instead, I've decided to remap fold to `Command + K, [`, and unfold to `Command+ K, ]`.
I kind of stole inspiration from the vim 'leader' key, where `Command + K`
is my leader, and indicates whatever comes after is a command. A more modal
approach, if you will.

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
