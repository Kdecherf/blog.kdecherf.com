HUGO?=hugo

BASEDIR=$(CURDIR)
OUTPUT?=public
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/$(OUTPUT)
BUILD?=build
BUILDDIR=$(BASEDIR)/$(BUILD)

SSH_HOST=shaolan.kdecherf.com
SSH_PORT=22
SSH_USER=blog
SSH_TARGET_DIR=~/httpdocs

DATE := $(shell date +'%Y-%m-%d %H:%M:%S')
ifdef SLUG
	CUSTSLUG = 1
endif
SLUG := $(shell echo '${NAME}' | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)
DATESLUG = $(shell echo '${DATE}' | cut -d' ' -f1)-${SLUG}
EXT ?= markdown

PORT ?= 1313

newpost:
ifdef NAME
	mkdir $(INPUTDIR)/blog/$(DATESLUG)
	echo "---"
	echo "title: $(NAME)" >  $(INPUTDIR)/blog/$(DATESLUG)/index.$(EXT)
	echo "date: $(DATE)" >> $(INPUTDIR)/blog/$(DATESLUG)/index.$(EXT)
ifdef CUSTSLUG
	echo "slug: $(SLUG)" >> $(INPUTDIR)/blog/$(DATESLUG)/index.$(EXT)
endif
	echo "tags:" >> $(INPUTDIR)/blog/$(DATESLUG)/index.$(EXT)
	echo "---"              >> $(INPUTDIR)/blog/$(DATESLUG)/index.$(EXT)
	echo ""              >> $(INPUTDIR)/blog/$(DATESLUG)/index.$(EXT)
	$(EDITOR) $(INPUTDIR)/blog/$(DATESLUG)/index.$(EXT)
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

newle:
ifdef NAME
	mkdir $(INPUTDIR)/lekdecherf/$(DATESLUG)
	echo "---"
	echo "title: $(NAME)" >  $(INPUTDIR)/le-kdecherf/$(DATESLUG)/index.$(EXT)
	echo "date: $(DATE)" >> $(INPUTDIR)/le-kdecherf/$(DATESLUG)/index.$(EXT)
ifdef CUSTSLUG
	echo "slug: $(SLUG)" >> $(INPUTDIR)/le-kdecherf/$(DATESLUG)/index.$(EXT)
endif
	echo "tags:" >> $(INPUTDIR)/le-kdecherf/$(DATESLUG)/index.$(EXT)
	echo "---"              >> $(INPUTDIR)/le-kdecherf/$(DATESLUG)/index.$(EXT)
	echo ""              >> $(INPUTDIR)/le-kdecherf/$(DATESLUG)/index.$(EXT)
	echo "![]()"              >> $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
	$(EDITOR) $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

date:
ifdef POST
	$(eval _POST = $(shell echo '${POST}' | sed -e 's;/$$;;g'))
	sed -e "s/^date: .*/date: $(DATE)/" -i $(_POST)/index.$(EXT)
	mv $(_POST) $(INPUTDIR)/blog/$(shell echo '${DATE}' | cut -d' ' -f1)-$(shell echo '${_POST}' | awk -F'/' '{print $$NF}' | cut -d- -f4-)
else
	@echo 'Variable POST is not defined.'
	@echo 'Do make date POST='"'"'Path to post'"'"
endif

html: clean
	$(HUGO) -e development -d $(BUILDDIR)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
	[ ! -d $(BUILDDIR) ] || rm -rf $(BUILDDIR)

publish: clean
	$(HUGO)

ssh_upload: publish
	scp -P $(SSH_PORT) -r $(OUTPUTDIR)/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

rsync_upload: publish
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

serve:
	$(HUGO) serve --port $(PORT)

.PHONY: html clean serve publish ssh_upload rsync_upload date newpost newle
