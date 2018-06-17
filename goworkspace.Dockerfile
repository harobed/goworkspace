FROM golang:1.10

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y bash-completion && \
    echo ". /etc/bash_completion" >> /root/.bashrc

ENV GOPATH=/usr/local/
ENV GOBIN=/usr/local/bin/

RUN curl -s -L https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 > /usr/local/bin/dep && \
    chmod u+x /usr/local/bin/dep && \
    go get -v -u github.com/spf13/cobra/cobra && \
    go get -v -u github.com/mitchellh/gox && \
    go get -v -u github.com/alecthomas/gometalinter && \
    gometalinter --install

RUN mkdir /code/
WORKDIR /code/
ENV GOPATH=/code/
ENV GOBIN=/code/bin/
ENV PATH=/code/bin/:$PATH
