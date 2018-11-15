const utils = require('./utils')
module.exports = {

	registerCustomer: function(StoreInstance, account) {
		const address = document.getElementById('customerAddress').value;
		const username = document.getElementById('customerUsername').value;
		const password = document.getElementById('customerPwd').value;
		StoreInstance.registerCustomer(address, username, password, {from: account, gas: 1000000}).then(function() {
			StoreInstance.RegisterCustomer(function(e, r) {
				console.log(r.args.message);
				window.App.setStatus(r.args.message);
			})
		})
	},
	customerLogin: function(StoreInstance, account) {
		const address = document.getElementById('customerLoginAddress').value;
		const password = document.getElementById('customerLoginPwd').value;
		StoreInstance.customerLogin(address, password, {from: account, gas: 1000000}).then(function() {
			StoreInstance.CustomerLogin(function(e, r) {
				console.log(r.args.message);
				window.App.setStatus(r.args.message);
				if(r.args.isSuccess){
					window.location.href = 'customer.html?account=' + address;
				}
			})
		})
	},
	showCustomerInfo: function(currentAccount, StoreInstance, account) {
		StoreInstance.getCustomerUsername.call(currentAccount, {from: account, gas: 1000000}).then(function(username) {
			StoreInstance.getBalance(currentAccount, {from: account, gas: 1000000}).then(function(balance) {
				console.log(utils.hexCharCodeToStr(username));
				console.log(balance.toString());
				document.getElementById('customerAddress').value = currentAccount;
				document.getElementById('customerUsername').value = utils.hexCharCodeToStr(username);
				document.getElementById('customerBalance').value = balance.toString();
			})
		})
	},
	customerBuyGood: function(currentAccount, StoreInstance, account) {
		const goodID = document.getElementById('goodID').value;
		StoreInstance.getPrice(goodID, {from: account, gas: 1000000}).then(function(price) {
			StoreInstance.customerbuyGood(currentAccount, goodID, {from: currentAccount, value: price, gas: 1000000}).then(function() {
				StoreInstance.CustomerbuyGood(function(e, r) {
					console.log(r.args.message);
					window.App.setStatus(r.args.message);
				})
			})
		})
	},
	customerTransferGood: function(currentAccount, StoreInstance, account) {
		const goodID = document.getElementById('sellgoodID').value;
		const buyer = document.getElementById('buyerAddress').value;
		StoreInstance.customerTransferGood(currentAccount, buyer, goodID, {from: account, gas: 2000000}).then(function() {
			StoreInstance.CustomerTransferGood(function(e, r) {
				console.log(r.args.message);
				window.App.setStatus(r.args.message);
			})
		})
	},
	customerShowGood: function(currentAccount, StoreInstance, account) {
		var postsRow = $('#table');

		postsRow.empty();

		const address = account;

		StoreInstance.getCustomerGoods(currentAccount, {from: account, gas: 2000000}).then(function(result) {
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
								'</tr>');
			}
			//console.log(postsRow.html());
		})
	},
	showGoodTransferProcess: function(currentAccount, StoreInstance, account) {
		var postsRow = $('#table_trans');

		postsRow.empty();

		const goodID = document.getElementById('searchgoodID').value;
		console.log(goodID);

		StoreInstance.getGoodTransferProcess(goodID, {from: account, gas: 2000000}).then(function(result) {
			postsRow.append('<tbody>' +
			'<tr>' +
			  '<th>商品流通过程</th>' +
			'</tr>' +
      		'</tbody>');
			for(i = 0; i < result[0]; i++) {
				postsRow.append('<tr class="alt">' + 
									'<td>' + result[1][i] + '</td>' +
								'</tr>');
			}
		})

	},
	showAllGoods: function(StoreInstance, account) {
		var postsRow = $('#table_all');

		postsRow.empty();

		const address = account;

		StoreInstance.getAllGoods({from: account, gas: 2000000}).then(function(result) {
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
								'</tr>');
			}
			//console.log(postsRow.html());
		})
	}

}







