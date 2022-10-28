---
layout: post
title: Resolving SSL Install in Jekyll
date: 2022-11-10
---

I set up a new machine recently, and ran into an issue when bundle installing
my [blog repo][blog_repo] for the first time.  I know I've run into this a
couple of times in the past, but never remember exactly what to do to fix it.
So going to write it here so I don't have to google it next time.

When I bundle install, I'm unable to install the `eventmachine` gem. It needs
to do some compilation with some C libraries (or something?...I don't
actually know), and needs to leverage the installed OpenSSL for this:

```sh
CXXFLAGS=-fdeclspec -Wall -Wextra -Wno-deprecated-declarations -Wno-ignored-qualifiers -Wno-unused-result
-Wno-address
creating Makefile

current directory: /Users/bear/.rvm/gems/ruby-3.1.2@ayunker.github.io/gems/eventmachine-1.2.7/ext
make DESTDIR\= clean

current directory: /Users/bear/.rvm/gems/ruby-3.1.2@ayunker.github.io/gems/eventmachine-1.2.7/ext
make DESTDIR\=
compiling binder.cpp
In file included from binder.cpp:20:
./project.h:119:10: fatal error: 'openssl/ssl.h' file not found
#include <openssl/ssl.h>
         ^~~~~~~~~~~~~~~
1 error generated.
make: *** [binder.o] Error 1

make failed, exit code 2

Gem files will remain installed in /Users/bear/.rvm/gems/ruby-3.1.2@ayunker.github.io/gems/eventmachine-1.2.7
for inspection.
Results logged to
/Users/bear/.rvm/gems/ruby-3.1.2@ayunker.github.io/extensions/arm64-darwin-21/3.1.0/eventmachine-1.2.7/gem_make.out

An error occurred while installing eventmachine (1.2.7), and Bundler cannot continue.
Make sure that `gem install eventmachine -v '1.2.7' --source 'https://rubygems.org/'` succeeds before
bundling.

In Gemfile:
  jekyll-feed was resolved to 0.15.1, which depends on
    jekyll was resolved to 4.2.0, which depends on
      em-websocket was resolved to 0.5.2, which depends on
        eventmachine
```

But I have multiple OpenSSL installed - the one that comes with macOS, and one
that I installed through [homebrew][homebrew] (not 100% sure why I need them
both...but I have them both...). So we need to tell `eventmachine` which
OpenSSL to use, because when given two choices, it picks neither. We can do
this by installing the gem on it's own with:

```sh
gem install eventmachine -v '1.2.7' -- --with-openssl-dir=[directory-here]
" In my case, my OpenSSL installed through homebrew is here: `/opt/homebrew/opt/openssl\@1.1` on my M1 Mac
```

Once that's successfully installed, we can re-bundle and it should succeed 🤞.

*(Editor's note: I know this is kinda hand-wave-y, because I don't fully
understand some of this stuff...but I guess I understand it well enough to fix
it?)*

[blog_repo]: https://github.com/ayunker/ayunker.github.io
[homebrew]: https://brew.sh/
