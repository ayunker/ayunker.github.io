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

# current setup requires local server to be running
link_check:
	lychee --base-url http://localhost:4000 \
		--exclude 'jetpens\.com' \
		_site/**/*.html \
