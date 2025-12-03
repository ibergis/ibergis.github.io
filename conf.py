# conf.py

import yaml
import sys
import os
from sphinx.roles import MenuSelection

project = 'IberGIS Documentation'
copyright = '2025, IberGIS'
author = 'IberGIS Authors'

# -- General configuration ---------------------------------------------------

# The master toctree document.
master_doc = 'docs/index'

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
html_logo = 'static/common/logo.png'

html_last_updated_fmt = '%Y %b %d, %H:%M %z'

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',
    'sphinx.ext.viewcode',
    'sphinx.ext.intersphinx',
    'sphinx.ext.doctest',
    'sphinx.ext.extlinks',
    'sphinxext.rediraffe',
    'sphinx_togglebutton',
    'sphinx_copybutton'
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['./themes']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = [
    'venv',
    '.github',
    'docs/user_manual/expressions/expression_help/*'
]

# -- Internationalisation ----------------------------------------------------

language = 'en'
locale_dirs = ['locale/']   # path is example but recommended.
gettext_compact = False     # optional.

# Enable numeric figure references
numfig = True

# The filename format for language-specific figures
figure_language_filename = '{path}{language}/{basename}{ext}'

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
html_theme = 'rtd_ibergis'

# https://sphinx-rtd-theme.readthedocs.io/en/stable/configuring.html#theme-options
# rtd / read the docs theme options:
html_theme_options = {
    # collapse_navigation: With this enabled, navigation entries are not expandable – the [+] icons next to each entry are removed. Default: True
    'collapse_navigation': True,
    # sticky_navigation: Scroll the navigation with the main page content as you scroll the page. Default: True
    'sticky_navigation': True,
    # navigation_depth: The maximum depth of the table of contents tree. Set this to -1 to allow unlimited depth. Default: 4
    'navigation_depth': 4,
    # includehidden:Specifies if the navigation includes hidden table(s) of contents – that is, any toctree directive that is marked with the :hidden: option. Default: True,
    # 'includehidden': True,
    # canonical_url: This will specify a canonical URL meta link element to tell search engines which URL should be ranked as the primary URL for your documentation. This is important if you have multiple URLs that your documentation is available through. The URL points to the root path of the documentation and requires a trailing slash.
    'canonical_url': 'https://ibergis.github.io/latest/en/',
    # display_version: If True, the version number is shown at the top of the sidebar. Default: True,
    'display_version': True,
    # logo_only: Only display the logo image, do not display the project name at the top of the sidebar. Default: False,
    'logo_only': False,
    # prev_next_buttons_location': Location to display Next and Previous buttons. This can be either bottom, top, both , or None. Default: 'bottom',
    'prev_next_buttons_location': 'both',
    # style_external_links': Add an icon next to external links. Default: False,
    'style_external_links': False,
    # style_nav_header_background': Changes the background of the search area in the navigation bar. The value can be anything valid in a CSS background property. Default: 'white',
    # 'style_nav_header_background': 'Gray',
    # Toc options
    # titles_only: When enabled, page subheadings are not included in the navigation. Default: False
    # 'titles_only': False,
}

# Add any paths that contain custom themes here, relative to this directory.
html_theme_path = ['./themes']

html_favicon = 'static/common/logo.png'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['static']


html_baseurl = 'https://ibergis.github.io/testing/en/'

# Set a bullet character for :menuselection: role
# easier to identify in non latin languages, e.g. japanese
MenuSelection.BULLET_CHARACTER = '\u25BA'  # '\N{BLACK RIGHT-POINTING POINTER}'

# for rtd themes, creating a html_context for the version/language part

# sys.path.insert(0, os.path.abspath('.'))

sys.path.insert(0, os.path.abspath('../../'))

with open('docs_conf.yml', 'r') as f:
    cfg = yaml.safe_load(f)


html_context = {
    # When a IberGIS version reaches end of life, set this to True to show an information
    # message on the top of the page.
    'outdated': False,
    # When a new IberGIS version is released, set this to False to remove the disclaimer
    # information message on the top of the page.
    'isTesting': False
}

# Add custom CSS when a top bar is needed to be shown (for testing or outdated versions)
if html_context['isTesting'] or html_context['outdated']:
    html_css_files = ['css/ibergis_topbar.css']

# Add custom tags to allow display of text based on the branch status
if html_context['isTesting']:
    tags.add('testing')
if html_context['outdated']:
    tags.add('outdated')

supported_languages = cfg['supported_languages'].split()
version_list = cfg['version_list'].replace(' ', '').split(',')
docs_url = 'https://ibergis.github.io/'


if version not in version_list:
    raise ValueError('IberGIS version is not in version list',
                     version, version_list)


context = {
    'versions': [[v, docs_url+v] for v in version_list],
    'supported_languages': [[l, docs_url+version+'/'+l] for l in supported_languages],

    # Do not display for outdated releases
    'display_github': not html_context['outdated'],
    'github_user': 'IberGIS',
    'github_repo': 'IberGIS-Documentation',
    'github_version': 'master/',
    'github_url': 'https://github.com/ibergis/ibergis.github.io',
}

if 'html_context' in globals():
    html_context.update(context)
else:
    html_context = context

# Supported image file formats and order of picking if named alike
from sphinx.builders.html import StandaloneHTMLBuilder
StandaloneHTMLBuilder.supported_image_types = [
    'image/svg+xml',
    'image/gif',
    'image/png',
    'image/jpeg'
]

# A list of warning codes to suppress arbitrary warning messages.
suppress_warnings = ["config.cache"]
