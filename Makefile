WEAVER ?= weaver

.PHONY: check generate

check:
	$(WEAVER) --future registry check --registry model

generate:
	$(WEAVER) --future registry generate \
		--registry model \
		--templates templates \
		markdown docs
