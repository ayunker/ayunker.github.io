server:
	bundle exec jekyll serve --future --drafts

outdated: ## Shows outdated packages.
	bundle outdated

draft TITLE:
	bundle exec jekyll draft {{TITLE}}

_promote PATH:
	bundle exec jekyll publish {{PATH}} --timestamp-format %Y-%m-%d

promote:
	fd -e md . _drafts/ | fzf | xargs just _promote

alias p := promote

# NOTE: current setup requires local server to be running
# NOTE: otherwise it can't resolve relative links like /uses.html
link_check:
	lychee --base-url http://localhost:4000 \
		--exclude 'jetpens\.com' \
		_site/**/*.html \

rcntly ED:
	awk -v edition={{ED}} '{gsub("EDITION", edition); print}' templates/rcntly.md.tmpl > _drafts/rcntly-{{ED}}.md

ssh:
	doctl compute ssh rivendell
