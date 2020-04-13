
default: all

MINIFY:=0
ELM_MAKE_FLAGS:=

LIBRARY_SOURCE=src
EXAMPLES_FOLDER=examples
WEBCOMPONENT_FOLDER=elm-canvas

LIBRARY_SOURCES:=$(shell find $(LIBRARY_SOURCE) -name '*.elm')
EXAMPLES:=$(wildcard $(EXAMPLES_FOLDER)/*.elm)
EXAMPLES_COMPILED:=$(patsubst $(EXAMPLES_FOLDER)/%.elm,public/%.js,$(EXAMPLES))

DOCS_OUTPUT=docs.json

ELM_CANVAS_COPY=public/elm-canvas.js

.PHONY=all
all: $(DOCS_OUTPUT) $(EXAMPLES_COMPILED) $(ELM_CANVAS_COPY)

public/%.js: $(EXAMPLES_FOLDER)/%.elm $(LIBRARY_SOURCES)
	@echo "Compiling $@ from $<"
	cd $(EXAMPLES_FOLDER)/ && elm make $(patsubst $(EXAMPLES_FOLDER)/%,%,$<) --output ../$@ $(ELM_MAKE_FLAGS)
	@if [ "$(MINIFY)" = "1" ]; then \
		echo "Minifying..."; \
		uglifyjs "$@" --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output="$@"; \
	fi

$(ELM_CANVAS_COPY): $(WEBCOMPONENT_FOLDER)/elm-canvas.js
	cp ./$(WEBCOMPONENT_FOLDER)/elm-canvas.js ./public/

.PHONY=clean
clean:
	rm -f $(EXAMPLES_COMPILED) $(DOCS_OUTPUT) $(ELM_CANVAS_COPY)

.PHONY=dist
dist: MINIFY:=1
dist: ELM_MAKE_FLAGS += --optimize
dist: all

$(DOCS_OUTPUT): $(LIBRARY_SOURCES)
	elm make --docs=$@

.PHONY=watch
watch:
	@find $(LIBRARY_SOURCE) $(EXAMPLES_FOLDER) $(WEBCOMPONENT_FOLDER) -name '*.elm' -or -name '*.js' | entr $(MAKE)

