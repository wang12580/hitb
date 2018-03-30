// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.10.0/priv/static/phoenix_html.js
$(document).ready(function() {
  // 将jquery的ajax加入到Vue对象中,vue对象里的this.$ajax就相当于是jquery的$.ajax
  Vue.prototype.$ajax = $.ajax;
  const BASE_URL = '/api/';
  // console.log(Vue)
  // 整个页面就是一个Vue对象,将所有属性都放到data里,将所有function都放到methods里
  const common = new Vue({
    el: '#body',
    // delimiters: ['${', '}'],
    data: {
      type : 'index',
      items: [],
      currentTime: new Date().toLocaleString(),
      username: 'someone manual strong movie roof episode eight spatial brown soldier soup motor'
    },
    methods: {
      getPeers: function() {
        this.type = 'getPeers'
        this.$ajax({
          type: 'GET',
          url: BASE_URL + 'peers',
          dataType: 'json',
          success: (res)=> {
            console.log(res)
            this.items = res.peers
          }
        });
      },
      getBlocks: function() {
        this.type = 'getBlocks'
        this.$ajax({
          type: 'GET',
          url: BASE_URL + 'blocks',
          dataType: 'json',
          success: (res)=> {
            this.items = res.blocks
          }
        });
      },
      getBlock: function(val) {
        this.type = 'getBlock'
        this.$ajax({
          type: 'GET',
          url: BASE_URL + 'getBlock?index=' + val,
          dataType: 'json',
          success: (res)=> {
            this.items = res.block
          }
        });
      },
      addPeer: function(){
        this.type = 'addPeer'
        this.$ajax({
          type: 'POST',
          url: BASE_URL + '/peer',
          data: {"host": "127.0.0.1", "port": 4001},
          dataType: 'json',
          success: (res)=> {
            this.items = res.result
          },
          error: (err)=> {
            this.items = ['连接节点失败']
            console.log(err);
          }
        });
      },
      addBlock: function(){
        this.type = 'addBlock'
        this.$ajax({
          type: 'POST',
          url: BASE_URL + '/block',
          data: {"data": new Date().toLocaleString()},
          dataType: 'json',
          success: (res)=> {
            this.items = res.result
          },
          error: (err)=> {
            this.items = ['创建区块失败']
            console.log(err);
          }
        });
      },
      test: function(){
        this.$ajax({
          type: 'get',
          url: BASE_URL + '/newAccount',
          // data: {"data": new Date().toLocaleString()},
          dataType: 'json',
          success: (res)=> {
            this.items = res.result
          },
          error: (err)=> {
            this.items = ['创建区块失败']
            console.log(err);
          }
        });
      },
      login: function() {
        console.log(this.username)
      }
    }  // vue-methods
  })  // new-Vue
});  // jquery-ready
