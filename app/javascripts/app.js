import '../stylesheets/app.css'


const customer = require('./customer')
const merchant = require('./merchant')

import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'

import StoreArtifact from '../../build/contracts/Store'

let StoreContract = contract(StoreArtifact)
let StoreInstance
let account

window.App = {
	init: function() {
		StoreContract.setProvider(window.web3.currentProvider);
		window.web3.eth.getAccounts(function(err, accounts) {
			if(err || accounts.length == 0) {
				window.App.setStatus('Can\'t get your accounts.');
				return;
			}
			account = accounts[0];
		})

		StoreContract.deployed().then(function(instance) {
			StoreInstance = instance;
		}).catch(function(err) {
			console.log(err);
		})
	},

	registerMerchant: function() {
		merchant.registerMerchant(StoreInstance, account);
	},
	merchantLogin: function() {
		merchant.merchantLogin(StoreInstance, account);
	},
	registerCustomer: function() {
		customer.registerCustomer(StoreInstance, account);
	},
	customerLogin: function() {
		customer.customerLogin(StoreInstance, account);
	},
	showMerchantInfo: function(currentAccount) {
		merchant.showMerchantInfo(currentAccount, StoreInstance, account);
	},
	merchantAddGood: function(currentAccount) {
		merchant.merchantAddGood(currentAccount, StoreInstance, account);
	},
	merchantShowGood: function(currentAccount) {
		merchant.merchantShowGood(currentAccount, StoreInstance, account);
	},
	showCustomerInfo: function(currentAccount) {
		customer.showCustomerInfo(currentAccount, StoreInstance, account);
	},
	customerBuyGood: function(currentAccount) {
		customer.customerBuyGood(currentAccount, StoreInstance, account);
	},
	customerShowGood: function(currentAccount) {
		customer.customerShowGood(currentAccount, StoreInstance, account);
	},
	customerTransferGood: function(currentAccount) {
		customer.customerTransferGood(currentAccount, StoreInstance, account);
	},
	showGoodTransferProcess: function(currentAccount) {
		customer.showGoodTransferProcess(currentAccount, StoreInstance, account);
	},
	showAllGoods: function(){
		customer.showAllGoods(StoreInstance, account);
	},
	setStatus: function (message) {
   		const status = document.getElementById('status')
    	status.innerHTML = message
  	}
}

window.addEventListener('load', function () {
  window.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:7545'))
  window.App.init()
})







