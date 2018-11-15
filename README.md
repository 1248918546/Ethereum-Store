# Ethereum-Store
a Ethereum-Store App based on truffle
前端使用webpack框架打包

## 环境准备

### 当前系统版本

go: go version go1.10 darwin/amd64

npm: 5.6.0

node: v8.11.3

Truffle v4.1.14 (core: 4.1.14)
Solidity v0.4.24 (solc-js)

ganache:Ganache CLI v6.1.0 (ganache-core: 2.1.0)

### 项目结构

```
├── app/
│   ├── index.html
│   ├── merchant.html
│   ├── customer.html
│   ├── javascripts/
│   │   ├── app.js
│   │   ├── customer.js
│   │   ├── merchant.js
│   │   └── utils.js
│   ├── stylesheets/
│   │   ├── app.css
├── contracts/
│   ├── Migrations.sol
│   └── Store.sol
├── migrations/
│   ├── 1_initial_migration.js
│   └── 2_deploy_contracts.js
├── package-lock.json
├── package.json
├── truffle-config.js
└── truffle.js
```

### 使用方法
首先打开ganacli客户端（端口：7545）
```
git clone https://github.com/1248918546/Ballot.git
npm install
truffle compile //合约编译
truffle migrate --network develop  //合约部署
npm run dev //运行前端页面
```


