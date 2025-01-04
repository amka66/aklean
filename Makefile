MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

.PHONY: pull clean build_root lint test status recent push update build run brun rerun
# .EXPORT_ALL_VARIABLES:
# .DELETE_ON_ERROR:
# .INTERMEDIATE:
# .SECONDARY:
.DEFAULT_GOAL := status

CACHED_MATHLIB ?= 1
ENABLE_DVC ?= 0
SYNC_DVC_CACHE ?= 0

ifeq ($(SYNC_DVC_CACHE),1)
RUN_CACHE = --run-cache
else
RUN_CACHE =
endif

pull:
	@echo "Pulling file changes..."
	git fetch --all --tags
	[[ -z  "$$(git branch --format "%(upstream:short)" --list "$$(git branch --show-current)")" ]] || git merge --ff-only
ifeq ($(ENABLE_DVC),1)
	dvc fetch $(RUN_CACHE)
	-dvc checkout
endif

clean:
	@echo "Deleting temporary files..."
	lake clean
	find . -type f -name '.DS_Store' -delete || true

build_root:
	@echo "Building root..."
ifeq ($(CACHED_MATHLIB),1)
	lake exe cache get
endif
	lake build

lint:
	@echo "Linting..."
	lake check-lint || exit 0 && lake lint

test:
	@echo "Running tests..."
	lake check-test || exit 0 && lake test

status:
	@echo "Reporting file status..."
	du -sh .
	git status
ifeq ($(ENABLE_DVC),1)
	dvc status
	dvc data status --granular
	dvc diff
	dvc status --cloud
endif

recent:	pull clean build_root lint test status

push: lint test
	@echo "Pushing file changes..."
ifeq ($(ENABLE_DVC),1)
	dvc push $(RUN_CACHE)
endif
	git push

update:
	@echo "Updating dependencies and manifest..."
	lake update
ifeq ($(CACHED_MATHLIB),1)
	lake exe cache get
endif

build:
	@echo "Building $(ARGS)..."
	lake build $(ARGS)

run:
	@echo "Running $(ARGS)..."
	lake env $(ARGS)

brun:
	@echo "Building and running $(ARGS)..."
	lake exe $(ARGS)

rerun: recent brun
