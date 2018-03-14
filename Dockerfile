FROM elixir:1.6.1-alpine

RUN apk update && apk add bash make git

ADD . /hitb_umbrella
WORKDIR /hitb_umbrella
CMD /bin/bash