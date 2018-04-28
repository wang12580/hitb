### docker命令
##### 取得镜像**
* docker pull postgres:9.6
* docker pull nginx
* docker pull bitwalker/alpine-elixir-phoenix
##### 运行PostgreSQL镜像**
* docker run --name postgres -e POSTGRES_PASSWORD=postgres -d postgres:9.6
##### 运行Phoenix镜像并启动项目**
* docker run --name hitb --link postgres:postgres  -v /host/path/hitb_umbrella:/opt/app/   -it bitwalker/alpine-elixir-phoenix
* mix deps.get
* mix ecto.create
* mix ecto.migrate
* mix init_db
* mix phx.server
* exit
* docker start -i hitb
##### 运行nginx**
* docker run --name nginx --link hitb:phoenix   -v /host/path/hitb/docs/nginx.conf:/etc/nginx/nginx.conf:ro -p 80:80 -d nginx
<!-- * docker build -t hitb .
* docker run --name hitb --link postgres:postgres -p 4000:4000 -v /d/git/hitb:/hitb -it hitb
* cd /hitb/hitb_umbrella -->
### build命令
* mix phx.digest
* MIX_ENV=prod mix release

### watch file changes
* /etc/sysctl.conf
* fs.inotify.max_user_watches=524288
* sudo sysctl -p
