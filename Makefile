



JEKYLL_FLAGS= --livereload --trace

# gh auth login

serve:
	# site located at http://localhost:4000
	bundle exec jekyll serve $(JEKYLL_FLAGS)


install:
	gem install jekyll bundler
	bundle update
	# github-pages gem should be run with Ruby version 2.7.x and not 3.0.0
	#bundle add webrick --version "~>1.7" --skip-install
	bundle install
	#bundle info [gemname]


downgrade:
	#pacman -R lolcat ruby-diff-lcs ruby-irb ruby-manpages ruby-optimist ruby-paint ruby-rainbow ruby-rdoc ruby-reline ruby-rspec-support ruby-tins rubygems ruby-rspec-core ruby-rspec-expectations ruby-rspec-mocks ruby-term-ansicolor ruby ruby-rspec
	#gem update --system 2.7.5
	paru -S ruby-build rbenv




