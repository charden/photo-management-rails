DOCKER = docker compose
DOCKER_UP = $(DOCKER) up
DOCKER_RUN = $(DOCKER) run --rm
CMD =
ENV = development

BACKEND = $(DOCKER_RUN) web
BUNDLE = $(BACKEND) bundle
RAILS = $(BACKEND) bundle exec rails
YARN = $(BACKEND) yarn

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":[^#]*? #| #"}; {printf "%-36s%s\n", $$1 $$3, $$2}'

default:
	$(DOCKER) $(CMD)

setup: # Install dependencies and db setup
	$(DOCKER) build
	$(BUNDLE) install
	$(RAILS) db:create
	$(RAILS) db:migrate
	$(RAILS) db:seed

start: # start development environment
	$(RAILS) db:migrate
	$(DOCKER_UP) -d

down: # stop development environment
	$(DOCKER) down

bundle: # use bundler
	$(BUNDLE) $(CMD)

yarn: # use yarn
	$(YARN) $(CMD)

.PHONY: test
test: # run tests
	$(RAILS) db:migrate RAILS_ENV=test
	$(RAILS) test

console: # rails console
	$(RAILS) console

migrate: # rails db:migrate
	$(RAILS) db:migrate

reset: # rails db:migrate:reset
	$(RAILS) db:migrate:reset
	$(RAILS) db:seed
