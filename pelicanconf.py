#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Kevin Decherf'
SITENAME = u'kdecherf (git)-[blog] %'
SITESUBTITLE = u'#FridayDeploymentWin'
SITEURL = ''

THEME = 'themes/fresh-sundown'

MD_EXTENSIONS = ['codehilite(css_class=highlight)','extra','fenced_code','codehilite']

PATH = 'content'

TIMEZONE = 'Europe/Paris'

DEFAULT_LANG = u'en'

ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}/'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'

PAGE_URL = '{slug}/'
PAGE_SAVE_AS = '{slug}/index.html'

ARCHIVES_SAVE_AS = 'archives/index.html'
ARCHIVES_URL = 'archives/'

AUTHORS_SAVE_AS = ''

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None

DEFAULT_PAGINATION = 5

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True