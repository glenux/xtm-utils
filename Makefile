DESTDIR=

NAME=xtm-utils
GEMNAME=xtm-utils
RUBYVERSION=1.8

BINDIR=$(DESTDIR)/usr/bin
MANDIR=$(DESTDIR)/usr/share/man
LIBDIR=$(DESTDIR)/usr/lib/ruby/$(RUBYVERSION)
DOCDIR=$(DESTDIR)/usr/share/doc/$(NAME)

RDOC=rdoc$(RUBYVERSION)
#RDOC=rdoc1.9
all: doc test

clean:
	rm -fr doc *.gem

build:

.PHONY: doc doc-reader
doc-reader: doc
	xdg-open file://`pwd`/doc/api/index.html

doc:
	rm -fr doc/api
	$(RDOC) \
		--promiscuous \
		--inline-source \
		--line-numbers \
		-o doc/api lib/
	# --diagram

.PHONY: test
test:
	$(MAKE) -C test

install: doc test
	# install libraries
	#
	find lib -name '*.rb' |while read FILE ; do \
		FILEPATH=`echo $$FILE |sed -e "s~^lib~$(LIBDIR)~"` ; \
		install -D -o root -g root -m 644 $$FILE $$FILEPATH ; \
		done
	# install binaries
	find bin -name '*.rb' |while read FILE ; do \
		FILEPATH=`echo $$FILE |sed -e "s~^bin~$(BINDIR)~"` ; \
		install -D -o root -g root -m 755 $$FILE $$FILEPATH ; \
		done
	# install documentation
	rm -fr $(DOCDIR)
	mkdir -p $(DOCDIR)
	cp -a doc $(DOCDIR)

gem:
	gem build $(GEMNAME).gemspec

gem_install:
	gem install $(GEMNAME)*.gem
