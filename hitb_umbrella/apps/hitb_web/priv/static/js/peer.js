$(document).ready(function() {
    // 将jquery的ajax加入到Vue对象中,vue对象里的this.$ajax就相当于是jquery的$.ajax
  Vue.prototype.$ajax = $.ajax;
  const BASE_URL = '/api';
  // 整个页面就是一个Vue对象,将所有属性都放到data里,将所有function都放到methods里
  const common = new Vue({
    el: '#peer',
    data: {
      type : '',
      items: [],
      log: ''
    },
    created: function () {
      this.getPeers()
    },
    methods: {
      getPeers: function() {
        this.type = 'getPeers'
        this.$ajax({
          type: 'GET',
          url: BASE_URL + '/peers',
          dataType: 'json',
          success: (res)=> {
            console.log(res)
            this.items = res.peers
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
            this.log = '链接节点成功'
          },
          error: (err)=> {
            this.log = '连接节点失败'
            console.log( this.log);
          }
        });
      }
    }
  })
})
