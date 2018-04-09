// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.10.0/priv/static/phoenix_html.js
$(document).ready(function() {
    // 将jquery的ajax加入到Vue对象中,vue对象里的this.$ajax就相当于是jquery的$.ajax
    Vue.prototype.$ajax = $.ajax;
    const BASE_URL = '/api';
    // console.log(Vue)
    // 整个页面就是一个Vue对象,将所有属性都放到data里,将所有function都放到methods里
    const common = new Vue({
      el: '#page',
      created: function() {
        this.getTransactions()
      },
      data: {
        type : 'index',
        items: [],
        currentTime: new Date().toLocaleString(),
        username: 'someone manual strong movie roof episode eight spatial brown soldier soup motor',
        transactions: [],
        accountPage: '账户信息',
        pay: {
          secret: '', amount: 0, recipientId: '000000', message: '测试使用'
        },
        secondPass: {
          secondPass: '', againSecondPass: ''
        },
        secondPublicKey: ''
      },
      methods: {
        getTransactions: function() {
          this.$ajax({
            type: 'GET',
            url: BASE_URL + '/getTransactions',
            dataType: 'json',
            success: (res)=> {
              this.transactions = res.data
              console.log(res.data[0])
            },
            error: (err)=> {
              this.items = ['登录失败']
              console.log(err);
            }
          });
        },
        info: function(value) {
          this.accountPage = value
          switch (value) {
            case '账户信息':
              break;
            case '二级密码':
            break;
            case '锁仓':
            break;
            default:
              break;
          }
        },
        getPays: function (value) {
          this.pay.secret= value
          this.$ajax({
            type: 'PUT',
            url: BASE_URL + '/addTransactions',
            data: this.pay,
            dataType: 'json',
            success: (res)=> {
              console.log(res.data)
            },
            error: (err)=> {
              this.items = ['交易失败']
              console.log(err);
            }
          });
        },
        getSecondPass: function (username) {
          if (this.secondPass.secondPass === this.secondPass.againSecondPass && this.secondPass.secondPass !== '') {
            this.$ajax({
              type: 'put',
              url: BASE_URL + '/addSignature',
              data: {username: username, password: this.secondPass.secondPass},
              // data: {"data": new Date().toLocaleString()},
              dataType: 'json',
              success: (res)=> {
                // this.items = res.result
                secondPublicKey = res.secondPublicKey
                this.items = ['二级密码创建成功']
                console.log(res)

              },
              error: (err)=> {
                this.items = ['创建区块失败']
                console.log(err);
              }
            });
          } else {
            this.items = ['两次密码输入不一致']
          }
        }
      }  // vue-methods
    })  // new-Vue
  });  // jquery-ready
