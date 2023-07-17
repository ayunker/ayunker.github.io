---
layout: post
title: sinatra on digital ocean
date: 2023-07-16
---
_(This one's gonna be a whopper.)_

I have a [side project][nazgul] that I wanted to share with the world wide web.
It's a super simple site built with [sinatra][sinatra], and it could
realistically be hosted anywhere - heroku, render, fly, AWS, etc, etc. However,
I saw this as an opportunity to set this up on a bare vm and learn all about
linux server management. In all my time as a developer, I've never done this in
such a barebones way from scratch. Things were always either setup ahead of
time and I never needed to touch it, or on heroku, or both.

So I thought I'd document all the steps that I took to set things up. There are
for sure better and more reproducible ways of doing this. For a more serious
app, definitely something like ansible/chef/nix/docker/terraform/etc...would be
the way to go. This is more a learning experience and digging in to all the
different parts.

## Spin up the VM

I chose [digital ocean][digital-ocean] as a provider and use one of their
droplets as a vm. But outside of the initial spin-up, the rest of the steps
should apply for any old vm in any old cloud.

Specs:
* Ubuntu 22.04 (Jammy Jellyfish!), the latest LTS release
* 1 vCPU (Regular Intel)
* 512mb RAM
* 10gb SSD

While this is more than sufficient for hosting my app, during setup I bumped
the specs up to 2gb RAM and 1 vCPU of Premium Intel. It made the installation
process *much* faster and with far fewer headaches. With only 512mb RAM,
installing ruby would take upwards of 20 minutes, and sometimes run out of
memory and fail. The upgrade was 100% worth it, and it's super simple to scale
the vm back down once things are setup.

## Create the user

Don't run everything as root! That's bad. Instead we'll create a user with sudo
privileges

``` sh
adduser samwise
usermod -aG sudo samwise
```

While still logged in as root, add your ssh public key to
`~/.ssh/authorized_keys`. Otherwise, you won't be able to ssh in as `samwise`.

Once all that's done, we can log out of root for good(?).

Ways to ssh in as `samwise`:

``` sh
ssh samwise@[ip address]
# DO only, using their cli tool
doctl compute ssh [name of vm] --ssh-user samwise
```

## Setup Firewall

[UFW][ufw] is already up and running, but we need to ensure that we allow ssh
and http and https traffic:

``` sh
sudo ufw allow OpenSSH
sudo ufw allow http
sudo ufw allow https
```

Now, running `sudo ufw status` should look something like this:

```
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
443                        ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)
443 (v6)                   ALLOW       Anywhere (v6)
80/tcp (v6)                ALLOW       Anywhere (v6)
```

## Certificates

Ok...this part is specific-ish to my app, but it derailed me for way longer
than I'd like to admit. The vm has OpenSSL3 installed, which is current (and
standard??). The Strava library that I'm using has [this thing where it will
check for the OpenSSL default cert file][strava-ssl-code]
(`OpenSSL::X509::DEFAULT_CERT_FILE`), and pass that down to Faraday to make the
requests. I think Faraday should be perfectly capable of figuring out where
these certs are and how to make an http request, but that's not what the gem
thinks. I'll stop my rant there.

Anyways, the problem is that `OpenSSL::X509::DEFAULT_CERT_FILE` resolves to
`/usr/lib/ssl/cert.pem`...which doesn't exist on ubuntu. I don't understand
this discrepancy - ubuntu is one of the most popular distros, and OpenSSL is an
essential library, why they are at odds here is perplexing. The certificate
does exist on ubuntu, just not there. It's enough to symlink it:

``` sh
sudo ln -s /etc/ssl/certs/ca-certificates.crt /usr/lib/ssl/cert.pem
```

My problem was I kept thinking it was some issue with my ruby install, and
wasted a lot of time trying to debug that before I realized I had to go deeper
down 😞.

## Install Ruby

Ok, so now we're ready to install ruby itself. I use [asdf][asdf] to manage my
rubies on my local machine, so I figured I'd use the same here.

But first, there's a whole bunch of dependencies we need to install. As of
writing this I think is the complete, minimal list of dependencies needed, but
definitely possible I could be missing some. Just read error messages, most of
the time they'll tell you what they need.

``` sh
apt install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev libpq-dev
```

Then on to ruby:

``` sh
# install asdf and asdf completions
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
# asdf can version manage many things, add ruby
asdf plugin add ruby
# since this is just for serving, not for dev, I don't care about docs.
# also, this is the step where bumping up the specs on the vm really makes a difference.
# spend a few extra cents and save yourself like 20 minutes
RUBY_CONFIGURE_OPTS=--disable-install-doc ~/.asdf/bin/asdf install ruby 3.2.2
asdf global ruby 3.2.2
gem update --system

```

Once this is done you should be able to `ruby -v` to get the version and `irb`
into a REPL. If not...read some error messages.

## Install Postgres

[Postgres][postgres] is probably overkill for this app, [sqlite][sqlite] I
think would probably be more appropriate and easier to setup. But I guess for
learning pg is the better option.

First we'll install postgres and some dependencies, and start it as a service:

``` sh
sudo apt install postgresql postgresql-contrib libpq-dev
sudo systemctl start postgresql.service
```

Once installed, we'll create a postgres user (for managing postgres), and login
as that user to create a postgres user matching our normal account plus a
database with that name. Postgres authentication is all role based, so if
you're logged in as `samwise` on the vm, then you have access to the `samwise`
db. You can connect to other DBs too (I think that requires superuser access or
something), but I had issues getting ruby to connect to other DBs so I left it
on `samwise` for now.

``` sh
sudo -i -u postgres
createuser --interactive #samwise, non superuser
createdb samwise
# connect to the db with
psql -d samwise
```

## Install Caddy

I was initially going to use [nginx][nginx] as my reverse proxy, but it looked
way too complicated for what I wanted. It's super powerful, but way more work
than I wanted to put in to setup. Maybe if you've used it before it's not as
bad, but coming in fresh it was a _lot_ to take in.

Instead, I decided to go with [caddy][caddy], and the configuration was exactly
what I was looking for.

To install, add caddy's gpg key and add them to apt's source list, then install
the thing:

``` sh
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
```

## Setup App

Now on to actually getting the app running! Only took us a little bit to get
here, but it should be mostly smooth sailing from here on out. I just created a
directory under `~/src` for nazgul, and cloned the repo there.

From there, we can bundle, and start the server with `ruby nazgul.rb`. Then if
we expose port `2015` to the internet in `ufw`, we can use a `Caddyfile` like
below and verify it's working by visiting `[droplet's ip address]:2015` and we
should see it in all it's glory.

```
:2015 {
	reverse_proxy localhost:4567
}
```

Now, running `ruby nazgul.rb` is fine whilst getting things set up, but as soon
as you disconnect from the vm, the process will stop and the site will go down.

We can solve this with [rackup][rackup], a gem that provides a cli for running
rack compatible apps. We'll setup a `config.ru` file like so and run it as a
daemon so it continues to run even after we disconnect:

``` ruby
require "./nazgul"

run Sinatra::Application
```

And run it as a daemon with `rackup -p 4567 -D`. Is there any way to stop it
once it's running? I don't know - reboot the whole vm?

## DNS Magic

Getting the DNS working was actually easier than I anticipated. I use
[namecheap][namecheap] for my domain registration and DNS, but it should be the
same for most providers. In namecheap, add an `A` record that points to the
droplet's ip address. This tells anyone visiting nazgul.cc to check out the
droplet. We'll also want to add a redirect for [www.nazgul.cc][www-nazgul] ->
[nazgul.cc][nazgul] (optional). Then we can simply update our Caddyfile to say
anything coming for nazgul.cc to hit up localhost:4567 for the goods.

```
nazgul.cc {
	reverse_proxy localhost:4567
}
```

At this point, we should be up and running!

[asdf]: https://asdf-vm.com/
[caddy]: https://caddyserver.com/
[digital-ocean]: https://www.digitalocean.com/
[namecheap]: https://www.namecheap.com/
[nazgul]: https://nazgul.cc/
[nginx]: https://www.nginx.com/
[postgres]: https://www.postgresql.org/
[rackup]: https://github.com/rack/rackup
[sinatra]: https://sinatrarb.com/
[sqlite]: https://www.sqlite.org/index.html
[strava-ssl-code]: https://github.com/ayunker/strava-ruby-client/blob/master/lib/strava/web/config.rb#L23
[ufw]: https://wiki.ubuntu.com/UncomplicatedFirewall
[www-nazgul]: http://www.nazgul.cc/
