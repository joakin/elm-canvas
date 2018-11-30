
default: all

MINIFY:=0
ELM_MAKE_FLAGS:=

LIBRARY_SOURCES:=$(wildcard src/*.elm)
EXAMPLES:=$(wildcard examples/*.elm)
EXAMPLES_COMPILED:=$(patsubst examples/%.elm,public/%.js,$(EXAMPLES))

DOCS_OUTPUT=docs.json

ELM_CANVAS_COPY=public/elm-canvas.js

.PHONY=all
all: $(DOCS_OUTPUT) $(EXAMPLES_COMPILED) $(ELM_CANVAS_COPY)

public/%.js: examples/%.elm $(LIBRARY_SOURCES)
	@echo "Compiling $@ from $<"
	cd examples/ && elm make $(patsubst examples/%,%,$<) --output ../$@ $(ELM_MAKE_FLAGS)
	@if [ "$(MINIFY)" = "1" ]; then \
		echo "Minifying..."; \
		uglifyjs "$@" --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output="$@"; \
	fi

$(ELM_CANVAS_COPY): elm-canvas/elm-canvas.js
	cp ./elm-canvas/elm-canvas.js ./public/

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
	@find src examples -name '*.elm' | entr $(MAKE)

