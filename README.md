# Golang workspace environment

This directory contains a Golang [workspace](https://golang.org/doc/code.html#Workspaces) environment used to develop and test my project.


## Prerequisite

* Docker and docker-compose

Prerequisites installation with [Brew](https://brew.sh/index_fr):

```
$ brew cask install docker
```


## Usage

```
$ make up-and-build
```

Launch project:

```
$ bin/darwin_amd64/myproject --help                                                                                                                     stephane at MacBook-Pro-de-KLEIN.local (-)(master)
A longer description that spans multiple lines and likely contains
examples and usage of using your application. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.
```

Some Makefile commands:

* `make enter`: Enter in `goworkspace` Docker container
* `make godep`: install Golang dependencies
* `make godep-ensure`: to update `Gopkg.toml` with package used in your project
* `make build`: build your project
* `make gox`: build multiplatform binaries
* `make build-goworkspace-docker-image`: to rebuild `goworkspace` Docker image
* `make lint`: execute Golang [Linter](https://github.com/alecthomas/gometalinter)


## How to contribute

See some guidelines in [contribute document](CONTRIBUTE.md).
