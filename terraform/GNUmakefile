REGION?=us-west-2

prepare:
	$(eval AWS := $(shell pass Hashbang/aws/terraform))
	$(eval AAK := $(word 1,$(AWS)))
	$(eval ASK := $(word 2,$(AWS)))

get:
	terraform get

init:
	terraform init

terraform: prepare
	AWS_ACCESS_KEY='$(AAK)' AWS_SECRET_KEY='$(ASK)' terraform $(MAKECMDGOALS) --var 'region=$(REGION)'

plan: get terraform

apply: get terraform

.PHONY: init plan apply
