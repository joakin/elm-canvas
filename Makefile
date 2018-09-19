
default: all

MINIFY:=0
ELM_MAKE_FLAGS:=

EXAMPLES:=$(wildcard examples/*.elm)
EXAMPLES_COMPILED:=$(patsubst examples/%.elm,public/%.js,$(EXAMPLES))

.PHONY=all
all: $(EXAMPLES_COMPILED) public/elm-canvas.js

public/%.js: examples/%.elm
	@echo "Compiling $@ from $<"
	cd examples/ && elm make $(patsubst examples/%,%,$<) --output ../$@ $(ELM_MAKE_FLAGS)
	@if [ "$(MINIFY)" = "1" ]; then \
		echo "Minifying..."; \
		uglifyjs "$@" --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output="$@"; \
	fi

public/elm-canvas.js: elm-canvas/elm-canvas.js
	cp ./elm-canvas/elm-canvas.js ./public/

.PHONY=clean
clean:
	rm -f $(EXAMPLES_COMPILED)

.PHONY=dist
dist: MINIFY:=1
dist: ELM_MAKE_FLAGS += --optimize
dist: all

.PHONY=watch
watch:
	@find src examples -name '*.elm' | entr $(MAKE)

