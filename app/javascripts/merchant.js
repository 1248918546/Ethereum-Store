const utils = require('./utils')
module.exports = {

	registerMerchant: function(StoreInstance, account) {
		const address = document.getElementById('merchantAddress').value;
		const username = document.getElementById('merchantUsername').value;
		const password = document.getElementById('merchantPwd').value;
		console.log(address);
		StoreInstance.registerMerchant(address, username, password, {from: account, gas: 1000000}).then(function() {
			StoreInstance.RegisterMerchant(function(e, r) {
				console.log(r.args.message);
				window.App.setStatus(r.args.message);
			})
		})
	},
	merchantLogin: function(StoreInstance, account) {
		const address = document.getElementById('merchantLoginAddress').value;
		const password = document.getElementById('merchantLoginPwd').value;
		console.log(address);
		console.log(password);
		StoreInstance.merchantLogin(address, password, {from: account, gas: 1000000}).then(function() {
			StoreInstance.MerchantLogin(function(e, r) {
				console.log(r.args.message);
				window.App.setStatus(r.args.message);
				if(r.args.isSuccess){
					window.location.href = 'merchant.html?account=' + address;
				}
			})
		})
	},
	showMerchantInfo: function(currentAccount, StoreInstance, account) {
		StoreInstance.getMerchantUsername.call(currentAccount, {from: account, gas: 1000000}).then(function(username) {
			StoreInstance.getBalance(currentAccount, {from: account, gas: 1000000}).then(function(balance) {
				console.log(utils.hexCharCodeToStr(username));
				console.log(balance.toString());
				document.getElementById('merchantUsername').value = utils.hexCharCodeToStr(username);
				document.getElementById('merchantAddress').value = currentAccount;
				document.getElementById('merchantBalance').value = balance.toString();
			})
		})
	},
	merchantAddGood: function(currentAccount, StoreInstance, account) {
		const goodID = document.getElementById('goodID').value;
		const goodName = document.getElementById('goodName').value;
		const price = parseInt(document.getElementById('goodPrice').value);
		StoreInstance.merchantAddGood(currentAccount, goodID, goodName, price, {from: account, gas: 1000000}).then(function() {
			StoreInstance.MerchantAddGood(function(e, r) {
				console.log(r.args.message);
				window.App.setStatus(r.args.message);
			})
		})
	},
	merchantShowGood: function(currentAccount, StoreInstance, account) {
		var postsRow = $('#table');

		postsRow.empty();

		StoreInstance.getMerchantGoods(currentAccount, {from: account, gas: 2000000}).then(function(result) {
			var length = parseInt(result[0]);
			var ids = result[1];
			var names = result[2];
			var prices = result[3];
			var addresses = result[4];
			postsRow.append('<tbody>' +
			'<tr>' +
			  '<th>商品id</th>' +
			  '<th>商品名</th>' +
			  '<th>商品价格</th>' +
			  '<th>商品所有者</th>' +
			'</tr>' +
      		'</tbody>');

			for(i = 0; i < length; i++) {
				//console.log(utils.hexCharCodeToStr(ids[i]), utils.hexCharCodeToStr(names[i]), parseInt(prices[i]));
				postsRow.append('<tr class="alt">' + 
									'<td>' + utils.hexCharCodeToStr(ids[i]) + '</td>' + 
									'<td>' + utils.hexCharCodeToStr(names[i]) + '</td>' + 
									'<td>' + parseInt(prices[i]) + '</td>' + 
									'<td>' + addresses[i] + '</td>' + 
								'</tr>')
			}
			//console.log(postsRow.html());
		})
	}
}






