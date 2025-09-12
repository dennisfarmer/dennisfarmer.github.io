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

install_tex_support:
	#https://jsr.io/@vrugtehagel/eleventy-tex
	npm install @vrugtehagel/eleventy-tex
	npx jsr add @vrugtehagel/eleventy-tex
	# modify .eleventy.js
	npm install @vscode/markdown-it-katex

