### docker命令
* docker pull postgres:9.6
* docker run --name postgres -e POSTGRES_PASSWORD=postgres -d postgres:9.6
* docker build -t hitb .
* docker run --name hitb --link postgres:postgres -p 4000:4000 -v /d/git/hitb:/hitb -it hitb
* cd /hitb/hitb_umbrella
* mix deps.get
* mix phx.server
* exit
* docker start -i hitb

### build命令
* mix phx.digest
* MIX_ENV=prod mix release

### watch file changes
* /etc/sysctl.conf
* fs.inotify.max_user_watches=524288
* sudo sysctl -p
