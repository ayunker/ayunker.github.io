---
layout: post
title: determinism rocks
date: 2025-02-26
---
*I'm not generally a big fan of AI at this current moment and I think there are
a few reasons for that. This is one of them, and I want to get it down on
paper/bytes to flesh it out.*

I want my software/tech/life to be deterministic (life only to an extent!).
Particularly, if I'm going to automate a task, I want it to do the right thing
100% of the time. **OR** consistently do it right or wrong with the same
inputs. If it's gonna fail with error A, if I it try again and again I want it
to fail every time with error A and not errors B, C, and/or D. 

I know this isn't even really true for automation before AI - and it's a really
hard thing to do - but I don't think AI moves us in the direction of
deterministic.

Let's say I want to create a new model in my [rails][] app. Consider the
following two ways to do this[^contrived]:

1. Hey AI - can you please generate me a model called Post that has attributes
   title (string), body (text), and a foreign key to author. Also create an
  rspec test file as well as factory. Also, create the db migration too.

2. `bin/rails g model post title:string body:text author:references`

**Which one will do exactly what I want it to time and again?**

Maybe that's the wrong question, because surely I can invoke the `rails g`
command incorrectly.

**Which one can I trust to generate the same output if I run it over and over
again?**

Believe me, I've seen 1 backfire on multiple occasions. Someone tests out a
prompt right before the demo, then 20 minutes later in the demo in front of a
group of people the AI does something different with the same prompt. Maybe it
has invalid syntax in the migration, maybe it "forgets" to generate the spec
file, but the point is it does something different with the same input.

You can't inspect the AI to understand why it did it that way this time around,
you gotta re-roll and hope for something better. If I wanted to, I could dig
into the rails documentation and/or source to figure out what's going wrong
with my generate command.

Now, I may need to learn/master the rails command line a bit more to leverage
2 But I guess that's where the craftsmanship comes into play - I need to be a
master of my tools rather than a casual user[^tools]. But once I get there,
then it's something I can rely on. I just can't say the same about AI at this
point.

---

[^contrived]: Yes its a contrived example but I think it gets the point across.

[^tools]: And of course this is very domain specific. If something like this
    exists in [phoenix][], the command or invocation will be different. So it's
tougher if you're a polyglot developer, but it comes down to the same thing -
know your tools.

[rails]: https://rubyonrails.org/
[phoenix]: https://www.phoenixframework.org/
