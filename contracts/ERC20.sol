// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _supply;
    string private _name;
    string private _symbol;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initial_supply
    ) {
        _name = name_;
        _symbol = symbol_;
        _mint(msg.sender, initial_supply);
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function transfer(address recipient, uint256 amount)
        public
        validAddress(msg.sender, recipient)
    {
        uint256 _senderBalance = _balances[msg.sender];
        require(_balances[msg.sender] >= amount);

        unchecked {
            _balances[msg.sender] = _senderBalance - amount;
        }

        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }

    function transferFrom(
        address owner,
        address recipient,
        uint256 amount
    ) public validAddress(owner, recipient) {
        uint256 senderAllowance = _allowances[owner][msg.sender];
        uint256 ownerBalance = _balances[owner];

        require(
            owner != msg.sender,
            "To transfer from your own account, use transfer()"
        );
        require(
            ownerBalance >= amount,
            "Transfer amount exceeds owner balance"
        );
        require(
            senderAllowance >= amount,
            "You have exceeded your allowance from this user"
        );

        unchecked {
            _allowances[owner][msg.sender] = senderAllowance - amount;
            _balances[owner] = ownerBalance - amount;
        }

        _balances[recipient] += amount;
        emit Approval(owner, msg.sender, senderAllowance - amount);
        emit Transfer(owner, recipient, amount);
    }

    function increaseAllowance(address spender, uint256 amount)
        public
        validAddress(msg.sender, spender)
    {
        _allowances[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
    }

    function decreaseAllowance(address spender, uint256 amount)
        public
        validAddress(msg.sender, spender)
    {
        uint256 allowance_ = _allowances[msg.sender][spender];
        require(allowance_ >= amount, "Current allowance is too small");
        unchecked {
            _allowances[msg.sender][spender] = allowance_ - amount;
        }

        emit Approval(msg.sender, spender, allowance_ - amount);
    }

    function _mint(address recipient, uint256 amount) internal {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        uint256 currentBalance = _balances[recipient];
        _balances[recipient] = currentBalance + amount;

        _supply = _supply + amount;

        emit Mint(recipient, amount);
    }

    modifier validAddress(address _sender, address _recipient) {
        require(_sender != address(0), "ERC20: transfer from the zero address");
        require(
            _recipient != address(0),
            "ERC20: transfer to the zero address"
        );
        _;
    }
}
