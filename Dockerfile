FROM golang:latest
LABEL maintainer="Tuckn <tuckn333@gmail.com>"
RUN go install github.com/x-motemen/blogsync@latest
RUN mkdir /root/.config
ENTRYPOINT ["/go/bin/blogsync"]
