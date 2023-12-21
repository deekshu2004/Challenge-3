// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// Here the overview of the challenge is to create  
// the contract in which owner only have the permission to mint the tokens to the given specific address
// And other is any user should be able to burn and transfer tokens.

// Here we are importing the ERC-20 Interface 
interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address spender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

// ERC-20 Token 
contract ERC20 is IERC20 {
    address public immutable owner; 
    uint public totalSupply;
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    // Here we are declaring the constructor and it is set to the contract owner
    constructor() {
        owner = msg.sender; 
    }
    // Here we are declaring modifier where only the owner can execute functions with this modifier
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can execute this function");
        _;
    }

    string public constant name = "SWASTIK"; 
    string public constant symbol = "ST"; 
    uint8 public constant decimals = 18; 
    // Here we have declared transfer function used to transfer the tokens 
    function transfer(address recipient, uint amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient Balance");
        
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // Here we have declared approve function used to approve the transaction 
    function approve(address spender, uint amount) external returns (bool) {
        require(amount > 0, "Amount for approval should be greater than zero");
        allowance[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // Here we have declared transferFrom() function which is used to transfer tokens from one account to another account 
    // It takes sender adress,receipent adress,amount as the params
    function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
        require(balanceOf[sender] >= amount, "Insufficient Balance");
        require(allowance[sender][msg.sender] >= amount, "Less approval to spend tokens");
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }
    // Here we have declared mint function it is used to mint new tokens and assign them to the sender
    function mint(uint amount) external onlyOwner {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // Here we have declared burn function which is used to burn the tokens from the particular account
    function burn(uint amount) external {
        require(amount > 0, "Amount should not be zero");
        require(balanceOf[msg.sender] >= amount, "Insufficient Balance");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }
}
