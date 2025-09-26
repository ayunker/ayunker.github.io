---
layout: post
title: apple store is microservices
date: 2025-09-26
---
The Apple Store is a system of microservices on a human scale. But instead of
loosely coupled servers/APIs, it's loosely coupled employees - each with their
own specific, fine-grained task to complete. I find it makes going into the
store more enjoyable - it makes me feel like a researcher observing some
natural system.

I went in to pick up an order the other day and here's how I bounced between
all the different ~~microservices~~ humans:

1. I walked in and spoke to the Greeter (1). I told them I was there for an
   order pick up, and they directed me to the Order Pickup Table.
2. At the Order Pickup Table, I spoke with another person (2) who checked me
   in. They scanned my barcode, and directed me to stand at the end of a
   different table, so that the Order Processor can find me.
3. I stand awkwardly at the end of the table until the Order Processor (3)
   arrives, and they too scan my barcode and verify what they have on their
   screen is indeed what I ordered.
4. Once confirmed, the Order Processor sends a request to the back of store to
   request the order is brought out to them.
5. The Runner (4) brings the order from the back to the Order Processor.
6. The Order Processor scans it and then hands it to me, thus completing the
   transaction.

That's at least 6 steps/4 people (probably more, who knows how many
~~microservices~~ people are working in the back!) involved in completing my
order pick up. It's microservices on a human scale.

Compare this to the alternative of having a counter and forming a queue in
front of it, and interacting with a single person to complete the transaction
end to end - aka monolithic architecture. Are the microservices better than
standing in a line? Who knows. Maybe Apple's ~~microservices~~ distributed
person architecture can scale better under heavy load like their software
counterparts are purported to? I generally avoid going at all when it's busy so
I don't know.

I think it's more likely Apple doesn't want people to see queues of people in
their stores, and that distributing people about the store looks more organic
and welcoming. Other ideas are available ¯\\_(ツ)_/¯.
