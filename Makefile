PY?=python
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
OUTPUT?=output
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/$(OUTPUT)
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

FTP_HOST=localhost
FTP_USER=anonymous
FTP_TARGET_DIR=/

SSH_HOST=shaolan.kdecherf.com
SSH_PORT=22
SSH_USER=kdecherf.com
SSH_TARGET_DIR=~/httpdocs

S3_BUCKET=my_s3_bucket

CLOUDFILES_USERNAME=my_rackspace_username
CLOUDFILES_API_KEY=my_rackspace_api_key
CLOUDFILES_CONTAINER=my_cloudfiles_container

DROPBOX_DIR=~/Dropbox/Public/

GITHUB_PAGES_BRANCH=gh-pages

PAGESDIR=$(INPUTDIR)/pages
DATE := $(shell date +'%Y-%m-%d %H:%M:%S')
ifdef SLUG
	CUSTSLUG = 1
endif
SLUG := $(shell echo '${NAME}' | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)
DATESLUG = $(shell echo '${DATE}' | cut -d' ' -f1)-${SLUG}
EXT ?= markdown

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

help:
	@echo 'Makefile for a pelican Web site                                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        (re)generate the web site          '
	@echo '   make clean                       remove the generated files         '
	@echo '   make regenerate                  regenerate files upon modification '
	@echo '   make publish                     generate using production settings '
	@echo '   make newpost [NAME=] [SLUG=] [DATE=]   create new blog post         '
	@echo '   make newle [NAME=] [SLUG=] [DATE=]     create new *Le Kdecherf post '
	@echo '   make serve [PORT=8000]           serve site at http://localhost:8000'
	@echo '   make devserver [PORT=8000]       start/restart develop_server.sh    '
	@echo '   make stopserver                  stop local server                  '
	@echo '   make ssh_upload                  upload the web site via SSH        '
	@echo '   make rsync_upload                upload the web site via rsync+ssh  '
	@echo '   make dropbox_upload              upload the web site via Dropbox    '
	@echo '   make ftp_upload                  upload the web site via FTP        '
	@echo '   make s3_upload                   upload the web site via S3         '
	@echo '   make cf_upload                   upload the web site via Cloud Files'
	@echo '   make github                      upload the web site via gh-pages   '
	@echo '                                                                       '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html'
	@echo '                                                                       '

newpost:
ifdef NAME
	mkdir $(INPUTDIR)/blog/$(DATESLUG)
	echo "Title: $(NAME)" >  $(INPUTDIR)/blog/$(DATESLUG)/post.$(EXT)
	echo "Category: Blog" >> $(INPUTDIR)/blog/$(DATESLUG)/post.$(EXT)
	echo "Tags:" >> $(INPUTDIR)/blog/$(DATESLUG)/post.$(EXT)
	echo "Date: $(DATE)" >> $(INPUTDIR)/blog/$(DATESLUG)/post.$(EXT)
ifdef CUSTSLUG
	echo "Slug: $(SLUG)" >> $(INPUTDIR)/blog/$(DATESLUG)/post.$(EXT)
endif
	echo ""              >> $(INPUTDIR)/blog/$(DATESLUG)/post.$(EXT)
	echo ""              >> $(INPUTDIR)/blog/$(DATESLUG)/post.$(EXT)
	$(EDITOR) $(INPUTDIR)/blog/$(DATESLUG)/post.$(EXT)
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

newle:
ifdef NAME
	mkdir $(INPUTDIR)/lekdecherf/$(DATESLUG)
	echo "Title: $(NAME)" >  $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
	echo "Date: $(DATE)" >> $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
	echo "Category: *Le Kdecherf" >> $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
ifdef CUSTSLUG
	echo "Slug: $(SLUG)" >> $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
endif
	echo ""              >> $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
	echo ""              >> $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
	echo "![]({attach})"              >> $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
	$(EDITOR) $(INPUTDIR)/lekdecherf/$(DATESLUG)/post.$(EXT)
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	kill -9 `cat pelican.pid`
	kill -9 `cat srv.pid`
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)

ssh_upload: publish
	scp -P $(SSH_PORT) -r $(OUTPUTDIR)/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

rsync_upload: publish
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

dropbox_upload: publish
	cp -r $(OUTPUTDIR)/* $(DROPBOX_DIR)

ftp_upload: publish
	lftp ftp://$(FTP_USER)@$(FTP_HOST) -e "mirror -R $(OUTPUTDIR) $(FTP_TARGET_DIR) ; quit"

s3_upload: publish
        s3cmd sync $(OUTPUTDIR)/ s3://$(S3_BUCKET) --acl-public --delete-removed --guess-mime-type

cf_upload: publish
	cd $(OUTPUTDIR) && swift -v -A https://auth.api.rackspacecloud.com/v1.0 -U $(CLOUDFILES_USERNAME) -K $(CLOUDFILES_API_KEY) upload -c $(CLOUDFILES_CONTAINER) .

github: publish
	ghp-import -b $(GITHUB_PAGES_BRANCH) $(OUTPUTDIR)
	git push origin $(GITHUB_PAGES_BRANCH)

.PHONY: html help clean regenerate serve devserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github
