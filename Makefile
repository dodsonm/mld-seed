# Includes a watcher for less files.
#
# PREREQUISITE: Node.js, BASH shell
#
# NOTE: You must have both a less & its corresponding css file in place before the
# watcher will pick it up.
#
# NOTE: Node dependencies are installed locally into the project
#
# TODO: add js minifying

HTML5_BP_REPO = git@github.com:dodsonm/html5-boilerplate.git
WEB_ROOT = $(CURDIR)/website

BOWERPM = $(CURDIR)/node_modules/.bin/bower
SUPERVISOR = $(CURDIR)/node_modules/.bin/supervisor

# less
LESSC = $(CURDIR)/node_modules/.bin/lessc
LESS_FLAGS = --yui-compress
LESS_ROOT = $(WEB_ROOT)/less
CSS_ROOT = $(WEB_ROOT)/css
CSS_FILES = $(shell find $(CSS_ROOT) -name *.css -print)

# coffee
COFFEEC = $(CURDIR)/node_modules/.bin/coffee
COFFEE_FLAGS = -wco
COFFEE_ROOT = $(WEB_ROOT)/coffee
JS_ROOT = $(WEB_ROOT)/js


install: node_modules js_modules

build: core install

clean:
	rm -rf website node_modules

core:
	git clone $(HTML5_BP_REPO) tmp
	cd tmp; git archive HEAD --format zip --output ../tmp.zip;
	rm -rf tmp/
	unzip tmp.zip -d $(WEB_ROOT)
	rm -f tmp.zip

node_modules:
	npm install

js_modules:
	$(BOWERPM) install;

css: $(CSS_FILES)

$(CSS_ROOT)/%.css: $(LESS_ROOT)/%.less
	$(LESSC) $(LESS_FLAGS) $< > $@

watcher-less:
	@$(SUPERVISOR) -q -w $(LESS_ROOT) -e less -n exit -x make css

watcher-coffee:
	@$(COFFEEC) $(COFFEE_FLAGS) $(JS_ROOT) $(COFFEE_ROOT)

