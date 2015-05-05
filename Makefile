NODE = node
TARGET_DIR = dist/
PANDOC = pandoc --tab-stop=2
GIT = git
PERL = perl
DATE = $(shell date "+%Y-%m-%d %H:%M %Z")

CONST_REPO = git@github.com:liberland/constitution.git
CONST_TARGET_DIR = $(TARGET_DIR)constitution/
CONST_FILE = constitution/Liberland-constitution.md
CONST_FILE_OUT = $(CONST_TARGET_DIR)Liberland-constitution

all: update gen

gen: gen_constitution

install:
	$(GIT) clone $(CONST_REPO) constitution

update:
	cd constitution && $(GIT) fetch && $(GIT) pull

gen_constitution:
	mkdir -p $(CONST_TARGET_DIR)
	cp $(CONST_FILE) $(CONST_FILE_OUT).md
	perl -pi -e '$$_ .= "\nLast updated: $(DATE)\n" if /^#[^#]+/' $(CONST_FILE_OUT).md
	$(PANDOC) $(CONST_FILE_OUT).md -V geometry:margin=1in -o $(CONST_FILE_OUT).pdf
	$(PANDOC) $(CONST_FILE_OUT).md -o $(CONST_FILE_OUT).html
	$(PANDOC) $(CONST_FILE_OUT).md -o $(CONST_FILE_OUT).epub
	$(PANDOC) $(CONST_FILE_OUT).md -o $(CONST_FILE_OUT).mobi

