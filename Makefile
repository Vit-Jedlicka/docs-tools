NODE = node
TARGET_DIR = dist/
PANDOC = pandoc --tab-stop=2
GIT = git

CONST_TARGET_DIR = $(TARGET_DIR)constitution/
CONST_FILE = constitution/Liberland-constitution.md
CONST_FILE_OUT = $(CONST_TARGET_DIR)Liberland-constitution

all: gen_constitution

install: constitution
	$(GIT) submodule init && $(GIT) submodule update

gen_constitution:
	mkdir -p $(CONST_TARGET_DIR)
	cp $(CONST_FILE) $(CONST_FILE_OUT).md
	$(PANDOC) $(CONST_FILE) -V geometry:margin=1in -o $(CONST_FILE_OUT).pdf
	$(PANDOC) $(CONST_FILE) -o $(CONST_FILE_OUT).html
	$(PANDOC) $(CONST_FILE) -o $(CONST_FILE_OUT).epub
	$(PANDOC) $(CONST_FILE) -o $(CONST_FILE_OUT).mobi

update:
	$(GIT) submodule update --remote --merge
