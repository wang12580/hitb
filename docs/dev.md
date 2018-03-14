### docker命令
* docker build -t hitb .
* docker run --name hitb -p 4000:4000 -v /d/git/hitb:/hitb -it hitb
* cd /hitb/hitb_umbrella
* mix deps.get
* mix phx.server
* exit
* docker start -i hitb

### build命令
* MIX_ENV=prod mix release

### watch file changes
* /etc/sysctl.conf
* fs.inotify.max_user_watches=524288
* sudo sysctl -p