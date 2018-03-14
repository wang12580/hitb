FROM elixir:1.6.1-alpine

RUN apk update && apk add bash make git inotify-tools

# ADD ./hitb_umbrella  /hitb_umbrella
# WORKDIR  /hitb_umbrella
CMD /bin/bash