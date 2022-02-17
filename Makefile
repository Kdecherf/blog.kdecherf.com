HUGO?=hugo
GIT?=git

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

DATETIME := $(shell date -Iseconds)
DATE := $(shell echo '${DATETIME}' | cut -d'T' -f1)
ifdef SLUG
	CUSTSLUG = 1
endif
SLUG := $(shell echo '${NAME}' | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)
DATESLUG = $(DATE)-$(SLUG)
EXT ?= markdown
FILENAME ?= index

PORT ?= 1313

newpost:
ifdef NAME
	$(eval POSTDIR=blog/$(DATESLUG))
	$(eval FILEPATH=$(POSTDIR)/$(FILENAME).$(EXT))
	$(HUGO) new $(FILEPATH)
	sed -e "s/^title:.*/title: \"$(NAME)\"/" -i $(INPUTDIR)/$(FILEPATH)
ifdef CUSTSLUG
	sed -e "s/^slug:.*/slug: \"$(SLUG)\"/" -i $(INPUTDIR)/$(FILEPATH)
else
	sed -e "/^slug:.*/d" -i $(INPUTDIR)/$(FILEPATH)
endif
	$(GIT) add $(INPUTDIR)/$(FILEPATH)
	$(GIT) commit -s -v -m "New post: '$(NAME)'"
	$(EDITOR) $(INPUTDIR)/$(FILEPATH)
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

newle:
ifdef NAME
	$(eval POSTDIR=le-kdecherf/$(DATESLUG))
	$(eval FILEPATH=$(POSTDIR)/$(FILENAME).$(EXT))
	$(HUGO) new $(FILEPATH)
	sed -e "s/^title:.*/title: \"$(NAME)\"/" -i $(INPUTDIR)/$(FILEPATH)
ifdef CUSTSLUG
	sed -e "s/^slug:.*/slug: \"$(SLUG)\"/" -i $(INPUTDIR)/$(FILEPATH)
else
	sed -e "/^slug:.*/d" -i $(INPUTDIR)/$(FILEPATH)
endif
	$(GIT) add $(INPUTDIR)/$(FILEPATH)
	$(GIT) commit -s -v -m "New post: '$(NAME)'"
	$(EDITOR) $(INPUTDIR)/$(FILEPATH)
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

finalize:
ifdef POST
	$(eval _POST = $(shell echo '${POST}' | sed -e 's;/$$;;g'))
	$(eval _ORIGDATE = $(shell echo '${_POST}' | sed -e 's;.*/\([0-9]*-[0-9]*-[0-9]*\)-.*;\1;'))
	$(eval _NEWPATH = $(shell echo '${_POST}' | sed -e 's;${_ORIGDATE};${DATE};'))
	sed -e "s/^date: .*/date: $(DATETIME)/" -i $(_POST)/$(FILENAME).$(EXT)
	sed -e "/^draft: /d" -i $(_POST)/$(FILENAME).$(EXT)
	$(if $(filter-out $(_POST),$(_NEWPATH)),mv '$(_POST)' '$(_NEWPATH)')
	$(if $(filter-out $(_POST),$(_NEWPATH)),$(GIT) rm -r '$(_POST)')
	$(GIT) add $(_NEWPATH)
	$(GIT) commit -s -v --amend -C HEAD
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
	$(HUGO) serve --buildDrafts --port $(PORT)

expose:
	ngrok http $(PORT) &
	sleep 3s && $(HUGO) serve --buildDrafts --liveReloadPort=443 --appendPort=false --baseURL=$$(curl --silent http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url' | sed -e 's@https://@@')

.PHONY: html clean serve publish ssh_upload rsync_upload finalize newpost newle
