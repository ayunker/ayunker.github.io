---
layout: post
title: fixing safari tab preview
date: 2021-02-11
---

With the update to Safari 14, hovering over a tab generates this large preview:

![](/assets/images/safari-tab-preview-1.jpg)

This feature does absolutely nothing for me. The vast majority of the websites
that I visit are composed of black text on a white background (or vice versa). I
gain zero additional insight into what the tab contains with this preview.

So, how to disable it?

That's where this gets interesting. And really, if it were more obvious, I
wouldn't even be writing this. The steps have been gleaned from [this answer on
Apple's community support forum][apple_forum_post], but I want to post here for
posterity (and redundancy).

1. In a terminal, enable the debug menu in safari:
``` sh
defaults write com.apple.Safari IncludeInternalDebugMenu 1
```
Note: this will only work if your terminal has full disk access. Otherwise,
there's an [alternate way by editing preference files][six_colors_post]...but I
didn't have luck with that.

2. Launch/restart Safari. Go to Debug menu -> Tab Features -> disable Show Tab
   Preview on Hover. 
3. Restart Safari
4. To hide the debug menu again, run
``` sh
defaults write com.apple.Safari IncludeInternalDebugMenu 0
```

There's a larger rant here about hiding cosmetic feature settings in a hidden
settings menu, but I'll reign that in for now. Suffice it to say, this was no
way intuitive and I never would have found it without help.

**Bonus**

Chrome also sort of has this feature. But 1) it's not as intrusive (though
possibly more redundant?), and 2) is easier to turn off. Surprisingly, Chrome
beats Safari in this round.

<img src="/assets/images/safari-tab-preview-2.jpg" width="50%">

1. In Chrome, open `chrome://flags`
2. Find **Tab Hover Cards**, and set to Disabled. Restart Chrome

[apple_forum_post]: https://discussions.apple.com/thread/251928059
[six_colors_post]: https://sixcolors.com/post/2020/09/enabling-the-debug-menu-in-safari-14-on-big-sur-and-catalina/
