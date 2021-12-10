pragma solidity ^0.8.0;

mapping(address => uint256) private _balances;
mapping(address => mapping(address => uint256)) private _allowances;

uint256 private _supply;
string private _name;
string private _symbol;

constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
}

function decimals() public view returns (uint8) {
    return 18;
}

function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
}

function allowance(address owner, address spender) public view returns (uint256) {
    return _allowances[owner][spender];
}

function transfer(address recipient, uint256 amount) public validAddress(msg.sender, _to) {
    uint256 _senderBalance = _balances[msg.sender];
    require(_balances[msg.sender] >= amount);

    unchecked { _balances[msg.sender] = _senderBalance - amount }

    _balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);
}

function transferFrom(address owner, address recipient, uint256 amount) public validAddress(owner, recipient) {
    uint256 allowance = _allowances[owner][msg.sender];
    uint256 ownerBalance = _balances[owner];

    require(ownerBalance >= amount, "Transfer amount exceeds owner balance");
    require(allowance >= amount, "You have exceeded your allowance from this user");

    unchecked { 
        _allowances[owner][msg.sender] = allowance - amount;
        _balances[owner] = ownerBalance - amount;
    }

    _balances[recipient] += amount;
    emit Approval(owner, msg.sender, allowance - amount);
    emit Transfer(owner, recipient, amount);

}

function increaseAllowance(address spender, uint256 amount) public validAddress(msg.sender, spender) {
    _allowances[msg.sender][spender] += amount;
    emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
}

modifier validAddress(address _sender, address _recipient) {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");
    _;
}

event Transfer(address sender, address recipient, uint256 amount);
event Approval(address owner, address sender, uint256 newAllowance);