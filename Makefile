# Run `make help` to display help
.DEFAULT_GOAL := help

# --- Global -------------------------------------------------------------------
MODS = e evy markdown pratt

all: lint run ## Build, test, check coverage and lint
	@if [ -e .git/rebase-merge ]; then git --no-pager log -1 --pretty='%h %s'; fi
	@echo '$(COLOUR_GREEN)Success$(COLOUR_NORMAL)'

ci: clean all check-uptodate ## Full clean build and up-to-date checks as run on CI

check-uptodate: tidy fmt
	test -z "$$(git status --porcelain)" || { git status; false; }

clean:: ## Remove generated files
	rm -rf $(addprefix docs/, $(MODS))

.PHONY: all check-uptodate ci clean

# --- Build --------------------------------------------------------------------
GOFILES = $(shell find . -name '*.go')

lint: ## Lint go source code
	golangci-lint run

run: ## Run index.html generator
	go run main.go $(MODS)

install: ## Build and install binaries in $GOBIN
	go install ./...

fmt: ## Format all go files with gofumpt, a stricter gofmt
	gofumpt -w $(GOFILES)

tidy: ## Tidy go modules with "go mod tidy"
	go mod tidy

.PHONY: fmt install lint run tidy

# --- Utilities ----------------------------------------------------------------
COLOUR_NORMAL = $(shell tput sgr0 2>/dev/null)
COLOUR_RED    = $(shell tput setaf 1 2>/dev/null)
COLOUR_GREEN  = $(shell tput setaf 2 2>/dev/null)
COLOUR_WHITE  = $(shell tput setaf 7 2>/dev/null)

help:
	@awk -F ':.*## ' 'NF == 2 && $$1 ~ /^[A-Za-z0-9%_-]+$$/ { printf "$(COLOUR_WHITE)%-25s$(COLOUR_NORMAL)%s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: help

define nl


endef
ifndef ACTIVE_HERMIT
$(eval $(subst \n,$(nl),$(shell bin/hermit env -r | sed 's/^\(.*\)$$/export \1\\n/')))
endif

# Ensure make version is gnu make 3.82 or higher
ifeq ($(filter undefine,$(value .FEATURES)),)
$(error Unsupported Make version. \
	$(nl)Use GNU Make 3.82 or higher (current: $(MAKE_VERSION)). \
	$(nl)Activate 🐚 hermit with `. bin/activate-hermit` and run again \
	$(nl)or use `bin/make`)
endif
