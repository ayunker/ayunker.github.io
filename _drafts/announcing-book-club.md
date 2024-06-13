---
layout: post
title: Announcing Book.Club
---

I made a thing! [465book.club][] is a simple web app that lets our book club
post potential books to read and vote for them to reach a consensus. That's it,
really.

This whole thing was driven by the difficulty we had had in collectively
deciding what to read next. It involved paper printouts, lots of shrugging and
indecisiveness. It also required candidates submitted before we met and a lot of
work on a single person to put that all together.

I don't want to be the guy who thinks the solution to every single problem is a
technical one, but this felt like an acceptable scenario. And I've found in the
couple of months we've used the app that it's helped spark conversation. It also
made it a lot easier (and less intimidating) to suggest books, too.

---

Anyways, [465book.club][] is a Rails app that leverages [Turbo Streams][] to
give it a SPA-like feel an update vote counts in realtime.

The general flow is to create a meeting (ours meets once per month) and start
adding books. Just need the title, author, and a link to goodreads so its easy
to check out the deets of a book. Books can be added before meeting, or during.

*screenshot of meeting index, meeting show*

Then we vote, and you can only vote for one book per meeting. Simple enough.

*screenshot of voted book*

I didn't want there to be user accounts. User accounts feel too *official*, and
requires effort for someone to sign up just to vote for a book. This means
there's no history of the books a person voted for, but I don't really think
that's something we need. 

So I just use the Rails session id to keep track of
who has voted for the purposes of limiting to one vote per person. It's just a
random string, nothing personally identifiable. It should be persistent unless
someone clears their browser data. Is it easily circumvented? Sure. But this is
book club, nobody's going to do something nefarious to make sure their book
comes out on top.


The coolest feature (to me, at least) is actually bog-standard [Turbo
Streams][]. Each books is connected to a stream, meaning it's connected to a
websocket on the server and will be notified anytime the book is updated. What
this means is that anytime someone votes, the book is updated and the new vote
count is pushed to the page. So we get realtime vote counts without refreshing
the page. Neat! It's a surprisingly little amount of code to get this
functionality. Rails magic at work. [^technical_aside]

---

Check out the [source][] on Github! Pull requests welcome, but keep in mind this is
built for my book club which may operate differently from yours. So I may reject
features that don't work for our club of books readers. In that case, fork away!

I've been wanting to build more small apps like this, and had a fun time doing
so. Hope to make some more like this in the future.

---

[^technical_aside]: There is a slight awkwardness I ran into with this. `Vot`ing
    for a `Book` creates a new `Vote` (a `Book` has_many `Votes`), but this
    doesn't broadcast the update to the `Book` itself so the update isn't pushed
    out over the stream. The solution I went with was to `touch` the associated
    `Book` when the `Vote` is created, which will trigger the update on the
    `Book`:

    ``` ruby
    class Vote < ApplicationRecord
      belongs_to :book, touch: true
    end
    ```

    This feels kind of heavy handed, but feels like the cleanest solution.
    Another option would have been to broadcast the `Book` update from the
    `Vote` model, but that didn't feel like it belonged there. Maybe some
    service class could have encapsulated it all? That's probably the way to go
    in a larger, more serious app. 

    I also experimented with using a [counter cache][] on the `Book` to keep
    track of the votes, but updates to the counter cache didn't trigger a
    broadcast either, so kinda defeated the purpose. 
