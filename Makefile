all: html

html:
	pandoc ./slides.md \
	--from=markdown+emoji \
	--to=revealjs \
	--output=slides.html \
	--standalone \
	--no-highlight \
	--template=./template-revealjs.html \
	--toc \
	--toc-depth=2 \
	--section-divs 
