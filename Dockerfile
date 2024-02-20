FROM golang:latest
LABEL maintainer="Tuckn <tuckn333@gmail.com>"
RUN go get github.com/x-motemen/blogsync
RUN mkdir /root/.config
ENTRYPOINT ["/go/bin/blogsync"]
