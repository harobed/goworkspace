DOCKER_ENV=$(shell test ! -f /.dockerenv; echo "$$?")

assert_in_docker:
ifeq ($(DOCKER_ENV),0)
	echo "Should be run under a container"; exit 1
endif

assert_out_docker:
ifeq ($(DOCKER_ENV),1)
	echo "Should not be run under a container"; exit 1
endif

.PHONY: build-goworkspace-docker-image
build-goworkspace-docker-image:
	docker-compose build goworkspace

.PHONY: up
up: assert_out_docker
	docker-compose up -d goworkspace

.PHONY: up-and-build
up-and-build: assert_out_docker up godep build gox


.PHONY: enter
enter: assert_out_docker
	docker-compose exec goworkspace bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"

.PHONY: clean
clean:
	docker-compose down
	rm -rf bin/ pkg/ src/myproject/vendor/

.PHONY: build
build:
ifeq ($(DOCKER_ENV),0)
	docker-compose exec goworkspace make -C . build
else
	go build -v -o bin/myproject -i myproject/
endif

.PHONY: gox
gox:
ifeq ($(DOCKER_ENV),0)
	docker-compose exec goworkspace make -C . gox
else
	gox \
		-os="darwin linux" \
		-arch="amd64" \
		-output "bin/{{.OS}}_{{.Arch}}/myproject" \
		myproject/
endif

.PHONY: godep
godep:
ifeq ($(DOCKER_ENV),0)
	docker-compose exec goworkspace make -C . godep
else
	mkdir -p /code/tmp/
	@# use /code/tmp/ to fix random bug like this:
	@# grouped write of manifest, lock and vendor: rename fallback failed: cannot rename /tmp/dep891346807/vendor to /code/src/mproject/vendor: copying directory failed: copying directory failed: copying directory failed: copying directory failed: copying file failed: chmod /code/src/myproject/vendor/github.com/bitly/go-simplejson/simplejson_go10.go: bad file descriptor
	(cd src/myproject/ && TMPDIR=/code/tmp/ dep ensure -v -vendor-only)
	rm -rf /code/tmp/
endif

.PHONY: godep-init
godep-init: assert_in_docker
	mkdir -p /code/tmp/
	@# use /code/tmp/ to fix random bug like this:
	@# grouped write of manifest, lock and vendor: rename fallback failed: cannot rename /tmp/dep891346807/vendor to /code/src/mproject/vendor: copying directory failed: copying directory failed: copying directory failed: copying directory failed: copying file failed: chmod /code/src/myproject/vendor/github.com/bitly/go-simplejson/simplejson_go10.go: bad file descriptor
	(cd src/myproject/ && TMPDIR=/code/tmp/ dep init -v)
	rm -rf /code/tmp/


.PHONY: godep-ensure
godep-ensure: assert_in_docker
	mkdir -p /code/tmp/
	@# use /code/tmp/ to fix random bug like this:
	@# grouped write of manifest, lock and vendor: rename fallback failed: cannot rename /tmp/dep891346807/vendor to /code/src/mproject/vendor: copying directory failed: copying directory failed: copying directory failed: copying directory failed: copying file failed: chmod /code/src/myproject/vendor/github.com/bitly/go-simplejson/simplejson_go10.go: bad file descriptor
	(cd src/myproject/ && TMPDIR=/code/tmp/ dep ensure -v)
	rm -rf /code/tmp/

.PHONY: lint
lint:
ifeq ($(DOCKER_ENV),0)
	docker-compose exec goworkspace make -C . lint
else
	gometalinter --config=.gometalinter.json src/myproject/...
endif
