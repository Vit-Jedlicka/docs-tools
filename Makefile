NODE = node
TARGET_DIR = dist/
PANDOC = pandoc --tab-stop=2 --toc --toc-depth=3
GIT = git
PERL = perl
DATE = $(shell date "+%Y-%m-%d %H:%M %Z")

LAWS_REPO = git@github.com:liberland/laws.git
LAWS_TARGET_DIR = $(TARGET_DIR)laws/
LAWS_FILE_OUT = $(LAWS_TARGET_DIR)Liberland-laws
LAWS_PANDOC = $(PANDOC) -S
LAWS_SOURCE_FILES = laws/drafts/*
LAWS_INDEX = metadata/laws-title.txt
LAWS_SOURCE = $(LAWS_INDEX) $(LAWS_SOURCE_FILES)

CONST_REPO = git@github.com:liberland/constitution.git
CONST_TARGET_DIR = $(TARGET_DIR)constitution/
CONST_FILE = constitution/Liberland-constitution.md
CONST_FILE_OUT = $(CONST_TARGET_DIR)Liberland-constitution

PDF_OPTIONS = -V geometry:margin=1in


all: update gen

gen: gen_constitution gen_laws

install:
	$(GIT) clone $(CONST_REPO) constitution
	$(GIT) clone $(CONST_REPO) laws

update:
	cd constitution && $(GIT) fetch && $(GIT) pull
	cd laws && $(GIT) fetch && $(GIT) pull

gen_constitution:
	mkdir -p $(CONST_TARGET_DIR)
	cp $(CONST_FILE) $(CONST_FILE_OUT).md
	perl -pi -e '$$_ .= "\nLast updated: $(DATE)\n" if /^#[^#]+/' $(CONST_FILE_OUT).md
	$(PANDOC) $(CONST_FILE_OUT).md $(PDF_OPTIONS) -o $(CONST_FILE_OUT).pdf
	$(PANDOC) --standalone --to=html5 $(CONST_FILE_OUT).md -o $(CONST_FILE_OUT).html
	$(PANDOC) $(CONST_FILE_OUT).md -o $(CONST_FILE_OUT).epub
	$(PANDOC) $(CONST_FILE_OUT).md -o $(CONST_FILE_OUT).mobi

gen_laws:
	mkdir -p $(LAWS_TARGET_DIR)
	rm $(LAWS_INDEX)
	echo "% Liberland Laws and Provisions\n%\n% Last updated: $(DATE)" > $(LAWS_INDEX)
	$(LAWS_PANDOC) -o $(LAWS_FILE_OUT).md $(LAWS_SOURCE_FILES)
	$(LAWS_PANDOC) --standalone --to=html5 -o $(LAWS_FILE_OUT).html $(LAWS_SOURCE)
	$(LAWS_PANDOC) $(PDF_OPTIONS) -o $(LAWS_FILE_OUT).pdf $(LAWS_SOURCE)
	$(LAWS_PANDOC) -o $(LAWS_FILE_OUT).epub --epub-metadata=metadata/laws.yaml $(LAWS_SOURCE_FILES)
	$(LAWS_PANDOC) -o $(LAWS_FILE_OUT).mobi $(LAWS_SOURCE)
	#perl -pi -e '$$_ .= "\nLast updated: $(DATE)\n" if /^#[^#]+/' $(LAWS_FILE_OUT).md

