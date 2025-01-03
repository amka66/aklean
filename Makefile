# TODO: File is WIP

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

.PHONY: pull sync clean test status recent push lock upgrade run rerun
# .EXPORT_ALL_VARIABLES:
# .DELETE_ON_ERROR:
# .INTERMEDIATE:
# .SECONDARY:
.DEFAULT_GOAL := status

ENABLE_TESTS ?= 1
ENABLE_DVC ?= 0
SYNC_DVC_CACHE ?= 0

ARGS ?= aklean

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
	uv run dvc fetch $(RUN_CACHE)
	-uv run dvc checkout
endif

sync:
	@echo "Syncing dependencies..."
# FIXME: add
# TODO: it should first create a virtual env if it doesn't exist

clean:
	@echo "Deleting temporary files..."
	find . -type f -name '.DS_Store' -delete || true
	find . -type d -name '.ipynb_checkpoints' -delete || true
# FIXME: add

ifeq ($(ENABLE_TESTS),1)
test:
	@echo "Running tests..."
# TODO: add
endif

status:
	@echo "Reporting file status..."
	du -sh .
	git status
ifeq ($(ENABLE_DVC),1)
	uv run dvc status
	uv run dvc data status --granular
	uv run dvc diff
	uv run dvc status --cloud
endif

recent:	pull sync clean test status
# TODO: it should first create a virtual env if it doesn't exist

push: test
	@echo "Pushing file changes..."
ifeq ($(ENABLE_DVC),1)
	uv run dvc push $(RUN_CACHE)
endif
	git push

lock:
	@echo "Locking dependencies..."
# FIXME: add

upgrade:
	@echo "Upgrading locked dependencies..."
# FIXME: add

run:
	@echo "Running main (args=$(ARGS))..."
# TODO: add

rerun: recent run
