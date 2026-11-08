PORT ?= 8000
HOST ?= 127.0.0.1
OUT := .preview
CSS := https://cdn.jsdelivr.net/npm/github-markdown-css@5.8.1/github-markdown.min.css

.PHONY: preview render clean help

help:
	@echo "make preview   Render profile/README.md with GitHub's renderer and serve it at http://$(HOST):$(PORT)/"
	@echo "make clean     Remove the $(OUT)/ build directory"

# Uses the GitHub Markdown API through the gh CLI, so the result matches github.com.
render:
	@rm -rf $(OUT) && mkdir -p $(OUT)
	@cp -R profile/assets $(OUT)/assets
	@{ \
	  echo '<!doctype html><html lang="en"><head><meta charset="utf-8">'; \
	  echo '<meta name="viewport" content="width=device-width, initial-scale=1">'; \
	  echo '<title>Ordo Systems profile preview</title>'; \
	  echo '<link rel="stylesheet" href="$(CSS)">'; \
	  echo '<style>body{margin:0}.markdown-body{box-sizing:border-box;max-width:1012px;margin:0 auto;padding:32px 16px}</style>'; \
	  echo '</head><body class="markdown-body">'; \
	  gh api markdown -f mode=gfm -f context=ordo-systems/.github -f text="$$(cat profile/README.md)"; \
	  echo '</body></html>'; \
	} > $(OUT)/index.html

preview: render
	@echo "Serving http://$(HOST):$(PORT)/ (Ctrl+C to stop)"
	python3 -m http.server $(PORT) --bind $(HOST) --directory $(OUT)

clean:
	rm -rf $(OUT)
