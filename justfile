server:
	bundle exec jekyll serve --future --drafts

outdated: ## Shows outdated packages.
	bundle outdated

draft TITLE:
	bundle exec jekyll draft {{TITLE}}

promote PATH:
	bundle exec jekyll publish {{PATH}}
