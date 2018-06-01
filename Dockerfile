FROM elixir:1.6.1-alpine

RUN apk update && apk add bash make git inotify-tools build-base

RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-2.27-r0.apk
RUN apk add glibc-2.27-r0.apk

# ADD ./hitb_umbrella  /hitb_umbrella
# WORKDIR  /hitb_umbrella
CMD /bin/bash