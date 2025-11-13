FROM ubuntu:20.04 as builder

RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential

COPY hello.c .

RUN gcc hello.c -fPIE -pie -o hello_world

FROM scratch

COPY --from=builder /hello_world /bin/
