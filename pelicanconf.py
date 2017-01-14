#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import urllib, hashlib

AUTHOR = u'Kevin Decherf'
SITENAME = u'kdecherf ~ %'
SITESUBTITLE = u'#FridayDeploymentWin'
SITEURL = ''

# Conf for pulling Gravatar Image
EMAIL = u'kevin@kdecherf.com'

ASSETS_VERSION = "v20150123"

THEME = 'themes/Nicholas'

MD_EXTENSIONS = ['codehilite(css_class=highlight)','extra','fenced_code']

PLUGIN_PATHS = ['plugins/']
PLUGINS = ['simple_footnotes', 'tag_cloud']

PATH = 'content'

TIMEZONE = 'Europe/Paris'

DEFAULT_LANG = u'en'

ARTICLE_URL = '{category}/{date:%Y}/{date:%m}/{date:%d}/{slug}/'
ARTICLE_SAVE_AS = '{category}/{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'

PAGE_URL = '{slug}/'
PAGE_SAVE_AS = '{slug}/index.html'

CATEGORY_SAVE_AS = '{slug}/index.html'
CATEGORY_URL = '{slug}/'

TAG_SAVE_AS = 'tag/{slug}/index.html'
TAG_URL = 'tag/{slug}/'

TAGS_SAVE_AS = 'tags/index.html'
TAGS_URL = 'tags/'

AUTHOR_SAVE_AS = ''
AUTHORS_SAVE_AS = ''
CATEGORIES_SAVE_AS = ''
ARCHIVES_SAVE_AS = ''
INDEX_SAVE_AS = ''

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None

DEFAULT_PAGINATION = 0
DISPLAY_CATEGORIES_ON_MENU = True
DISPLAY_PAGES_ON_MENU = True

STATIC_PATHS = [
        'images',
        'misc/kdecherf.asc',
        'lekdecherf',
        'blog',
]

EXTRA_PATH_METADATA = {
        'misc/kdecherf.asc': {'path': 'kdecherf.asc'}
}

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
