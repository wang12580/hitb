### 本项目参考以下项目
* [Asch](https://github.com/AschPlatform/asch) Asch is an efficient, flexible, safe and decentralized application platform, which was initially designed to lower the barrier to entry for developers.The services provided by the Asch platform include a public chain and a set of application SDKs.
* [Oniichain](https://github.com/freester1/Oniichain) simple block chain in elixir 
* [coincoin](https://github.com/robinmonjo/coincoin) Blockchain based cryptocurrency proof-of-concept in Elixir. Feedback welcome
* [ZeroNet](https://github.com/HelloZeroNet/ZeroNet) ZeroNet - Decentralized websites using Bitcoin crypto and BitTorrent network
* [ipfs](https://github.com/ipfs/ipfs) Peer-to-peer hypermedia protocol

### 项目开发
* ./init.sh
* ./dev.sh
* iex --sname dev -S mix phx.server

### 临时命令
* curl -H 'Content-Type: application/json' localhost:4000/api/block -X POST -d '{"data": "cooldata"}'

* curl localhost:4000/api/blocks

* curl -H 'Content-Type: application/json' localhost:4000/api/peer -X POST -d '{"host": "127.0.0.1", "port": 4001}'

* curl localhost:4000/api/peers

### 区块链各层
#### 数据层:repos,使用mnesia
#### 网络层:peers,
#### 安全层:block
#### 共识层:block
#### 激励层:token
#### 应用层:share,文件共享