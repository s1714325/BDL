//Joe DE 
//s1714325

pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

contract token {
    
    using SafeMath for uint256;
    
    //variables and mappings
    uint256 tokenprice;
    mapping (address => uint) private balances;
    mapping (address => bool) public alreadyenrolled;
    address public owner;
    uint public clientCount = 0;
    uint256 purchaseamount;
    uint256 transferamount;
    uint256 sellamount;
    uint256 totaltokenvalue;
    bytes32 tokenname;
    address[] adresses;
    
    //events
    event Purchase(address buyer, uint256 amount);
    event Transfer(address sender, address reciever, uint256 amount);
    event Sell(address seller, uint256 amount);
    event Price(uint256 price);
    event Enroll(address user);
    
    //functions
    
    constructor() public payable {
        owner = msg.sender;
        require(msg.value > 9 wei);
    }
    
    function enroll() public returns (uint) {
        if (alreadyenrolled[msg.sender] == true){
            return balances[msg.sender];
        }
        else {
            clientCount++;
            balances[msg.sender] = 0;
            alreadyenrolled[msg.sender] = true;
            adresses.push(msg.sender);
            emit Enroll(msg.sender);
            return balances[msg.sender];
        }
    }
    
    function buytoken(uint256 amount) public payable returns (bool) {
        purchaseamount = amount.mul(tokenprice);
        require(msg.value == purchaseamount);
        balances[msg.sender] += amount;
        emit Purchase(msg.sender, msg.value.div(tokenprice));
        return true;
    }
    
    function transfer(address recipient, uint256 amount) public returns (bool) {
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function sellToken(uint256 amount) public payable returns (bool) {
        sellamount = amount.mul(tokenprice);
        require(msg.value == sellamount);
        balances[msg.sender] -= amount;
        msg.sender.transfer(sellamount);
        return true;
    }
    
    function changePrice(uint256 price) public returns (bool) {
        require(msg.sender == owner);
        uint i = 0;
        uint totaltokens = 0;
        for(i; i < clientCount; i++) {
        totaltokens += balances[adresses[i]];
        }
        totaltokenvalue = price.mul(totaltokens);
        require(address(this).balance >= totaltokenvalue);
        tokenprice = price;
        return true;
        
    }
    
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
    
    function contractsBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
}
