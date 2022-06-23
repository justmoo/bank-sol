pragma solidity 0.8.13;

contract Bank {
    address payable public owner;
    uint256 accountCounter;
    mapping(address => uint256) public balances;
    mapping(address => bool) public isRegistered;
    mapping(address => Account) public accounts;

    constructor() payable {
        owner = payable(msg.sender);
        accountCounter = 0;
    }

    struct Account {
        uint256 accountId;
        address userAddress;
        uint256 balance;
        string name;
        uint256 transactions;
    }

    modifier isRegister() {
        require(isRegistered[msg.sender] == true, "Not registered");
        _;
    }
    // modifier onlyOwner
    // modifier enoughBalance

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier enoughBalance(uint256 amount) {
        require(balances[msg.sender] >= amount, "Not enough balance");
        _;
    }

    function register(string memory _name) public {
        require(isRegistered[msg.sender] == false, "already registerd");
        isRegistered[msg.sender] = true;
        // create account
        Account memory acc = Account({
            accountId: accountCounter,
            userAddress: msg.sender,
            balance: 0,
            name: _name,
            transactions: 0
        });
        accounts[msg.sender] = acc;
        accountCounter++;
    }

    function deposit() public payable isRegister {
        // add the value to the balance
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public isRegister enoughBalance(amount) {
        // check  if register
        // check if balance is enough
        // decreament the amount
        balances[msg.sender] -= amount;
        // transfer the money
        payable(msg.sender).transfer(amount);
    }
}
