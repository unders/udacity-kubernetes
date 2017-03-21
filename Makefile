.PHONY: help
help:
	@cat Makefile

.PHONY: bootstrap
bootstrap:
	@./bin/bootstrap.sh

.PHONY: info
info:
	@gcloud info

