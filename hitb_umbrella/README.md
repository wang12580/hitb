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
* :observer.start()
* r(Block.S1)
* Block.S1.create("a")
* Block.S1.lookup("a")

### 临时命令
* curl -H 'Content-Type: application/json' localhost:4000/api/block -X POST -d '{"data": "cooldata"}'

* curl localhost:4000/api/blocks

* curl -H 'Content-Type: application/json' localhost:4000/api/peer -X POST -d '{"host": "127.0.0.1", "port": 4001}'

* curl localhost:4000/api/peers

### 区块链是多维的，每一维都是一条独立的区块链（后一个区块记录前一个区块的hash值）
* 第0维是非医疗业务的token事件，{token支付者-token接受者}，包括挖矿、转账交易
* 第1维是就诊事件，{医疗服务接受者-医疗服务提供者}，包括门诊、急诊、住院、体检
* 第2维是医疗服务接受者的就诊事件，{医疗服务提供者}，从第一维中抽取出来的，相当于一个人一生的就诊事件记录
* 第3维是每一次就诊事件的医嘱事件（诊疗流程），{医嘱}，包括预约/挂号/问诊/体格检查/检验/检查/处方/入院/手术/护理/康复
* 第4维是每一项医嘱事件的执行事件，{医嘱执行}

### 区块链是隐私保护的
* 医疗服务接受者：{姓名+性别+籍贯代码+出生日期}的hash值，籍贯代码+出生日期就是身份证号的前6+8位
* 医疗服务提供者：{名称+机构代码}的hash值

#### 数据层:repos-使用mnesia
#### 网络层:peers
#### 安全层:block
#### 共识层:block
#### 激励层:token
#### 应用层:share-文件共享，drg-分组/分析，emrhelp病案帮助