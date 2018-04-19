$(document).ready(function() {
    // 将jquery的ajax加入到Vue对象中,vue对象里的this.$ajax就相当于是jquery的$.ajax
    Vue.prototype.$ajax = $.ajax;
    const BASE_URL = '/api';
    // 整个页面就是一个Vue对象,将所有属性都放到data里,将所有function都放到methods里
    let common = {}
    common = new Vue({
      el: '#block2',
      data: {
        type : '',
        items: [],
        blockInfo: null,
        blockTd: null,
        blockBotice: '新建区块'
      },
      created: function () {
        this.getBlocks()
      },
      methods: {
        getBlocks: function() {
          this.type = 'getBlocks'
          this.$ajax({
            type: 'GET',
            url: BASE_URL + '/blocks',
            dataType: 'json',
            success: (res)=> {
              this.items = res.blocks
              console.log(this.items)
            }
          });
        },
        getBlock: function(val) {
          console.log(val)
          this.type = 'getBlock'
          this.$ajax({
            type: 'GET',
            url: BASE_URL + '/getBlockByHash?hash=' + val,
            dataType: 'json',
            success: (res)=> {
              this.blockInfo = res.block
              this.blockTd = 'id'
              console.log(res)
            }
          });
        },
        getPreviousHash: function (val) {
          console.log(val)
          // getTransactionsByBlockHash
          this.$ajax({
            type: 'GET',
            url: BASE_URL + '/getTransactionsByBlockHash?hash=' + val,
            dataType: 'json',
            success: (res)=> {
              this.blockInfo = res.data
              // this.blockTd = 'id'
              console.log(res)
            }
          });
          this.type = 'getPreviousHash'
          this.blockTd = 'transaction'
        },
        getAddress: function (val) {
          console.log(val)
          // getTransactionsByBlockHash
          this.$ajax({
            type: 'GET',
            url: BASE_URL + '/getAccountByAddress?address=' + val,
            dataType: 'json',
            success: (res)=> {
              this.blockInfo = res.data
              // this.blockTd = 'id'
              console.log(res)
            }
          });
          this.type = 'getPreviousHash'
          this.blockTd = 'transaction'
        },
        addBlock: function(){
          this.type = 'addBlock'
          this.$ajax({
            type: 'POST',
            url: BASE_URL + '/block',
            data: {"data": new Date().toLocaleString()},
            dataType: 'json',
            success: (res)=> {
              this.items = res
              this.blockBotice = '创建区块'
              location.reload();
            },
            error: (err)=> {
              this.items = ['创建区块失败']
              console.log(err);
            }
          });
        },
      }
    })
  })