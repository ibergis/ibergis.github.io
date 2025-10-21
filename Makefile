# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
LANG            = en
# currently we are building for the following languages, if you want yours to be build: ask!
LANGUAGES       = en # es_CR es_ES ca
SPHINXOPTS      =
# Use the tag i18n to filter text based on whether we are translating or not
SPHINXINTLOPTS  = $(SPHINXOPTS) -D language=$(LANG) -t i18n
SPHINXBUILD     ?= sphinx-build
SPHINXINTL      ?= sphinx-intl
SOURCEDIR       = .
BUILDDIR        = build
# to be able to run the Makefile in a docker you have to mount (with -v) your site dir on /site
SITEDIR         = ./site
VERSION         = testing

# needed for Sphinx > 4.5?
export LC_ALL=C.UTF-8

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

springclean:
	rm -rf $(BUILDDIR)
	# all .mo files
	-find $(SOURCEDIR)/locale/*/LC_MESSAGES/ -type f -name '*.mo' -delete

gettext:
	echo "$(SPHINXBUILD) $(SOURCEDIR) $(BUILDDIR) $(SPHINXOPTS) $(O)"
	@$(SPHINXBUILD) -M gettext "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

update-po: gettext
	@echo "Updating .po files for languages: $(LANGUAGES)"
	@for LANG in $(LANGUAGES) ; do \
		$(SPHINXINTL) update -p $(BUILDDIR)/gettext -l $$LANG; \
	done

sync-to-i18n:
	@echo "Syncing i18n files for languages: $(LANGUAGES)"
	./scripts/sync_translations_to_i18n.sh $(VERSION)

sync-from-i18n:
	@echo "Syncing i18n files from i18n to gettext"
	./scripts/sync_translations_from_i18n.sh $(VERSION)

html:
	echo "$(SPHINXOPTS) $(SPHINXINTLOPTS)"
	if [ $(LANG) != "en" ]; then \
		$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/html/$(LANG)" $(SPHINXINTLOPTS) $(0); \
	else \
		$(SPHINXBUILD) -b html -n --keep-going "$(SOURCEDIR)" "$(BUILDDIR)/html/$(LANG)" $(SPHINXOPTS) $(0); \
	fi

zip:
	mkdir -p $(BUILDDIR)/zip;
	(cd $(BUILDDIR)/html; \
	zip -r IberGIS-$(VERSION)-Documentation-$(LANG).zip $(LANG)/;)
	mv $(BUILDDIR)/html/IberGIS-$(VERSION)-Documentation-$(LANG).zip $(BUILDDIR)/zip/;

site: html zip
	@mkdir -p $(SITEDIR)/$(VERSION)/$(LANG)/docs
	rsync -hvrzc --delete --progress $(BUILDDIR)/html/$(LANG)/* $(SITEDIR)/$(VERSION)/$(LANG)

full: html zip
	make LANG=$(LANG) pdf;

# this will build ALL languages, AND tries to rsync them to the web dir on qgis2
# to be able to run this you will need a key on the server
all: springclean
	@for LANG in $(LANGUAGES) ; do \
		make LANG=$$LANG site; \
	done
	rsync -hvrzc $(BUILDDIR)/zip $(SITEDIR)/;