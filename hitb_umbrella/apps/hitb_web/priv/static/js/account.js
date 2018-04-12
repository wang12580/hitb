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
        this.getPublicKey()
      },
      data: {
        type : 'index',
        items: [],
        currentTime: new Date().toLocaleString(),
        username: '',
        transactions: [],
        accountPage: '账户信息',
        pay: {
          publicKey: '', amount: 0, recipientId: '', message: ''
        },
        secondPass: {
          secondPass: '', againSecondPass: ''
        },
        paySuccess: '',
        payInfo: '',
        secondPublicKey: '',
        publicKeys: [],
        secondPassword: '',
        accoutnInfo: '',
        getTransactionById: {},
        getAccountByPublicKey: {},
        getAccountByAddress: {}
      },
      methods: {
        getTransactions: function() {
          this.$ajax({
            type: 'GET',
            url: BASE_URL + '/getTransactions',
            dataType: 'json',
            success: (res)=> {
              this.transactions = res.data
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
          if (this.secondPassword !== '') {
            this.pay.secondPassword= this.secondPassword
          }
          this.pay.publicKey= value
          this.$ajax({
            type: 'PUT',
            url: BASE_URL + '/addTransactions',
            data: this.pay,
            dataType: 'json',
            success: (res)=> {
              this.paySuccess = res.success
              this.payInfo = res.info
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
                if (res.success === true) {
                  this.items = ['二级密码创建成功']
                  location.reload();
                }
              },
              error: (err)=> {
                this.items = ['创建区块失败']
                console.log(err);
              }
            });
          } else {
            this.items = ['两次密码输入不一致']
          }
        },
        getPublicKey: function () {
          this.$ajax({
            type: 'GET',
            url: BASE_URL + '/getAccountsPublicKey',
            dataType: 'json',
            success: (res)=> {
              this.publicKeys = res.publicKeys
            },
            error: (err)=> {
              this.items = ['创建区块失败']
              console.log(err);
            }
          });
        },
        accountID: function (value) {
          this.$ajax({
            type: 'GET',
            url: BASE_URL + `/getTransaction?id=${value}`,
            dataType: 'json',
            success: (res)=> {
              this.accoutnInfo = 'id'
              const { signature, signSignature, senderId, recipientId, asset, args, ...c } = res.data;
              this.getTransactionById = c
            },
            error: (err)=> {
              this.items = ['创建区块失败']
              console.log(err);
            }
          });
        },
        accountSenderPublicKey: function (value) {
          this.$ajax({
            type: 'GET',
            url: BASE_URL + `/getAccountByPublicKey?publicKey=${value}`,
            dataType: 'json',
            success: (res)=> {
              this.accoutnInfo = 'PublicKey'
              let { username, u_username, u_secondSignature, u_nameexist, u_multisignatures, u_multimin, u_multilifetime, u_isDelegate, u_delegates, u_balance, secondSignature, secondPublicKey, rewards, rate, producedblocks, nameexist, multisignatures, multimin, multilifetime, missedblocks, lockHeight, isDelegate, index, fees, delegates, blockId, ...c } = res.account;
              this.getAccountByPublicKey = c
            },
            error: (err)=> {
              this.items = ['创建区块失败']
              console.log(err);
            }
          });
        },
        accountRecipientId: function (value) {
          this.$ajax({
            type: 'GET',
            url: BASE_URL + `/getAccountByAddress?address=${value}`,
            dataType: 'json',
            success: (res)=> {
              this.accoutnInfo = 'RecipientId'
              this.getAccountByAddress = res.account
            },
            error: (err)=> {
              this.items = ['创建区块失败']
              console.log(err);
            }
          });
        }
      }  // vue-methods
    })  // new-Vue
  });  // jquery-ready
