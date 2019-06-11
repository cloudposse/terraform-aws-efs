SHELL := /bin/bash

# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md

# Specify to use TF 0.12 and export the default AWS region so that
# terraform validate can run properly.
export TERRAFORM_VERSION ?= 0.12.1
export AWS_DEFAULT_REGION ?= us-east-1

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

## Override the terraform/validate from build-harness
## so that it is TF 0.12 friendly.
terraform/validate:
	@$(TERRAFORM) validate

## Lint terraform code
lint:
	$(SELF) terraform/install terraform/get-modules terraform/get-plugins terraform/lint terraform/validate
