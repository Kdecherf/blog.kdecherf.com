#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import urllib, hashlib

AUTHOR = u'Kevin Decherf'
SITENAME = u'kdecherf (git)-[blog] %'
SITESUBTITLE = u'#FridayDeploymentWin'
SITEURL = ''

# Conf for pulling Gravatar Image
EMAIL = u'kevin@kdecherf.com'
DEFAULT_GRV_URL = u'http://www.example.com/default.jpg'
GRV_SIZE = 120

ASSETS_VERSION = "v20150123"

# construct gravatar URL
GRV_URL = "//www.gravatar.com/avatar/" + hashlib.md5(EMAIL.lower()).hexdigest() + "?"
GRV_URL += urllib.urlencode({'s':str(GRV_SIZE)})

THEME = 'themes/cleanelican'

MD_EXTENSIONS = ['codehilite(css_class=highlight)','extra','fenced_code','codehilite']

PLUGIN_PATHS = ['plugins/']
PLUGINS = ['simple_footnotes']

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
