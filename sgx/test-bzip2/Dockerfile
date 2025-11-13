FROM ubuntu:20.04 as builder
RUN truncate -s 1G /tmp/file1G 

FROM busybox
COPY --from=builder /tmp/file1G /tmp/
COPY ./test-bzip2.sh /bin/
