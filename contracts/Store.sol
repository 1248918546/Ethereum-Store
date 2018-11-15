pragma solidity ^0.4.24;


library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
          return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Utils {
    
    function stringToBytes32(string memory source)  internal pure returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }

    function bytes32ToString(bytes32 x)  internal pure returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}

contract Store is Utils {

    using SafeMath for uint256;

    address owner;
    
    struct Customer {
        address customerAddr; //顾客地址
        bytes32 username;     //顾客用户名
        bytes32 password;     //顾客密码
        bytes32[] customerGoods; //顾客购买的商品
    }
    
    struct Merchant {
        address merchantAddr; //商户地址
        bytes32 username;     //商户用户名
        bytes32 password;     //商户密码
        bytes32[] merchantGoods;  //商户发布的商品
    }
    
    struct Good {
        bytes32 goodID;     //商品ID
        bytes32 goodname;   //商品名
        uint price;         //商品价格
        bool isBought;      //商品是否已被购买
        address[] transferProcess;   //商品流通过程
    }

    mapping(address => Customer) customers;   //所有顾客
    mapping(address => Merchant) merchants;   //所有商户
    mapping(bytes32 => Good) goods;           //所有商品
    mapping(bytes32 => address) goodToOwner;  //根据商品Id查找该件商品当前拥有者

    address[] customersAddr;  //所有顾客的地址
    address[] merchantsAddr;  //所有商户的地址
    bytes32[] goodsID;        //所有商品

    //约束条件——合约创建者
    modifier onlyOwner() {
        if(msg.sender == owner)
        _;
    }

    //约束条件——商品当前拥有者
    modifier onlyOwnerOf(bytes32 _goodID) {
        require(msg.sender == goodToOwner[_goodID]);
        _;
    }

    //合约构造函数
    constructor() public {
        owner = msg.sender;
    }

    //获得owner地址
    function getOwner() constant public returns (address) {
        return owner;
    }

    //判断用户是否已注册
    function isCustomerRegistered(address _customerAddr) internal view returns (bool) {
        bool isRegistered = false;
        for(uint i = 0; i < customersAddr.length; i++) {
            if(customersAddr[i] == _customerAddr) {
                return isRegistered = true;
            }
        }
        return isRegistered;
    }

    //判断商户是否已注册
    function isMerchantRegistered(address _merchantAddr) internal view returns (bool) {
        bool isRegistered = false;
        for(uint i = 0; i < merchantsAddr.length; i++) {
            if(merchantsAddr[i] == _merchantAddr) {
                return isRegistered = true;
            }
        }
        return isRegistered;
    }

    //判断商品是否已存在
    function isGoodExisted(bytes32 _goodID) internal view returns (bool) {
        bool isExisted = false;
        for(uint i = 0; i < goodsID.length; i++) {
            if(goodsID[i] == _goodID) {
                return isExisted = true;
            }
        }
        return isExisted;
    }

    //顾客注册
    event RegisterCustomer(address _customerAddr, bool isSuccess, string message); 
    function registerCustomer(address _customerAddr, string _username, string _password) public {
        if(!isCustomerRegistered(_customerAddr)) {
            customers[_customerAddr].customerAddr = _customerAddr;
            customers[_customerAddr].username = stringToBytes32(_username);
            customers[_customerAddr].password = stringToBytes32(_password);
            customersAddr.push(_customerAddr);
            emit RegisterCustomer(_customerAddr, true, "注册成功");
            return;
        } else {
            emit RegisterCustomer(_customerAddr, false, "地址已被注册，注册失败");
            return;
        }
    }

    //商户注册
    event RegisterMerchant(address _merchantAddr, bool isSuccess, string message);
    function registerMerchant(address _merchantAddr, string _username, string _password) public {
        if(!isMerchantRegistered(_merchantAddr)) {
            merchants[_merchantAddr].merchantAddr = msg.sender;
            merchants[_merchantAddr].username = stringToBytes32(_username);
            merchants[_merchantAddr].password = stringToBytes32(_password);
            merchantsAddr.push(_merchantAddr);
            emit RegisterMerchant(_merchantAddr, true, "注册成功");
            return;
        } else {
            emit RegisterMerchant(_merchantAddr, false, "地址已被注册，注册失败");
            return;
        }
    }

    //顾客登录
    event CustomerLogin(address _customerAddr, bool isSuccess, string message);
    function customerLogin(address _customerAddr, string _password) public {
        if(isCustomerRegistered(_customerAddr)) {
            if(customers[_customerAddr].password == stringToBytes32(_password)) {
                emit CustomerLogin(_customerAddr, true, "登录成功");
                return;
            } else {
                emit CustomerLogin(_customerAddr, false, "密码错误，登录失败");
                return;
            }
        } else {
            emit CustomerLogin(_customerAddr, false, "地址尚未注册，登录失败");
            return;
        }
    }

    //商户登录
    event MerchantLogin(address _merchantAddr, bool isSuccess, string message);
    function merchantLogin(address _merchantAddr, string _password) public{
        if(isMerchantRegistered(_merchantAddr)) {
            if(merchants[_merchantAddr].password == stringToBytes32(_password)) {
                emit MerchantLogin(_merchantAddr, true, "登录成功");
                return;
            } else {
                emit MerchantLogin(_merchantAddr, false, "密码错误，登录失败");
                return;
            }
        } else {
            emit MerchantLogin(_merchantAddr, false, "地址尚未注册，登录失败");
            return;
        }
    }

    //商户发布商品
    event MerchantAddGood(address _merchantAddr, bool isSuccess, string message);
    function merchantAddGood(address _merchantAddr, string _goodID, string _goodname, uint _price) public {
        bytes32 id = stringToBytes32(_goodID);
        if(!isGoodExisted(id)) {
            goods[id].goodID = id;
            goods[id].goodname = stringToBytes32(_goodname);
            goods[id].price = _price;
            goods[id].isBought = false;
            goods[id].transferProcess.push(_merchantAddr);

            goodsID.push(id);
            merchants[_merchantAddr].merchantGoods.push(id);
            goodToOwner[id] = _merchantAddr;
            emit MerchantAddGood(_merchantAddr, true, "添加商品成功");
            return;
        } else {
            emit MerchantAddGood(_merchantAddr, false, "商品已存在，添加商品失败");
            return;
        }
    }

    //顾客购买商品
    event CustomerbuyGood(address _customerAddr, bool isSuccess, string message);
    function customerbuyGood(address _customerAddr, string _goodID) public payable {
        bytes32 id = stringToBytes32(_goodID);
        require(msg.value == goods[id].price);
        if(isGoodExisted(id)) {
            if(!goods[id].isBought) {
                goodToOwner[id].transfer(msg.value);
                goodToOwner[id] =  _customerAddr;

                goods[id].isBought = true;
                goods[id].transferProcess.push( _customerAddr);

                customers[ _customerAddr].customerGoods.push(id);
                emit CustomerbuyGood( _customerAddr, true, "购买成功");
                return;
            }else {
                emit CustomerbuyGood( _customerAddr, false, "商品已被购买，购买失败");
                return;
            }
        }
        else {
            emit CustomerbuyGood( _customerAddr, false, "商品不存在");
            return;
        }
    }

    //顾客转让商品
    event CustomerTransferGood(address _seller, bool isSuccess, string message);
    function customerTransferGood(address _seller, address _buyer, string _goodID) {
        bytes32 id = stringToBytes32(_goodID);
        if(goodToOwner[id] != _seller) {
            emit CustomerTransferGood(_seller, false, "您不是该商品的拥有者");
            return;
        } else {
            if(isCustomerRegistered(_buyer)) {
                goodToOwner[id] = _buyer;
                customers[_buyer].customerGoods.push(id);
                goods[id].transferProcess.push(_buyer);
                emit CustomerTransferGood(_seller, true, "转让成功");
                return;
            } else {
                emit CustomerTransferGood(_seller, false, "您所要转让的地址尚未注册");
                return;
            }
        }
    }

    //查看商品流通过程
    function getGoodTransferProcess(string _goodID) constant public returns (uint, address[]) {
        bytes32 id = stringToBytes32(_goodID);
        return (goods[id].transferProcess.length, goods[id].transferProcess);
    }

    //商户查看已发布商品
    function getMerchantGoods(address _merchant) constant public returns (uint, bytes32[], bytes32[], uint[], address[]) {
        uint length = merchants[_merchant].merchantGoods.length;
        bytes32[] memory goodsName = new bytes32[](length);
        uint[] memory goodsPrice = new uint[](length);
        address[] memory goodsOwner = new address[](length);

        for(uint i = 0; i < length; i++) {
            goodsName[i] = goods[merchants[_merchant].merchantGoods[i]].goodname;
            goodsPrice[i] = goods[merchants[_merchant].merchantGoods[i]].price;
            goodsOwner[i] = goodToOwner[merchants[_merchant].merchantGoods[i]];
        }

        return (length, merchants[_merchant].merchantGoods, goodsName, goodsPrice, goodsOwner);
    }

    //顾客查看已购买商品
    function getCustomerGoods(address _customer) constant public returns (uint, bytes32[], bytes32[], uint[], address[]) {
        uint length = customers[_customer].customerGoods.length;
        bytes32[] memory goodsName = new bytes32[](length);
        uint[] memory goodsPrice = new uint[](length);
        address[] memory goodsOwner = new address[](length);

        for(uint i = 0; i < length; i++) {
            goodsName[i] = goods[customers[_customer].customerGoods[i]].goodname;
            goodsPrice[i] = goods[customers[_customer].customerGoods[i]].price;
            goodsOwner[i] = goodToOwner[customers[_customer].customerGoods[i]];
        }

        return (length, customers[_customer].customerGoods, goodsName, goodsPrice, goodsOwner);
    }


    //查看所有商品
    function getAllGoods() constant public returns (uint, bytes32[], bytes32[], uint[], address[]) {
        uint length = goodsID.length;
        bytes32[] memory goodsName = new bytes32[](length);
        uint[] memory goodsPrice = new uint[](length);
        address[] memory goodsOwner = new address[](length);

        for(uint i = 0; i < length; i++) {
            goodsName[i] = goods[goodsID[i]].goodname;
            goodsPrice[i] = goods[goodsID[i]].price;
            goodsOwner[i] = goodToOwner[goodsID[i]];
        }

        return (length, goodsID, goodsName, goodsPrice, goodsOwner);

    }
    function getPrice(string _goodID) constant public returns (uint) {
        return goods[stringToBytes32(_goodID)].price;
    }

    function getBalance(address addr) constant public returns (uint) {
        return addr.balance;
    }

    function getMerchantUsername(address merchant) constant public returns (bytes32) {
        return merchants[merchant].username;
    }

    function getCustomerUsername(address customer) constant public returns (bytes32) {
        return customers[customer].username;
    }
    //顾客转让商品
    //顾客查看商品流通过程
}



















