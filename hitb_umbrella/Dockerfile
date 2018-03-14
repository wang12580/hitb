FROM elixir:1.6.1-alpine

RUN apk update && apk add bash make git

ADD . /app
WORKDIR /app
RUN make release
CMD _build/prod/rel/hitb_umbrella/bin/hitb_umbrella console
