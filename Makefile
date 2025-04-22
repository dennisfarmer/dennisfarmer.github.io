build:
	npx eleventy --serve

push:
	git add .
	git commit -m "updated website"
	git push

install:
	npm install @11ty/eleventy --save-dev

build_prod:
	npm eleventy
