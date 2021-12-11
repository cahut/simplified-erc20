// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transfer(address recipient, uint256 amount) external;

    function transferFrom(
        address owner,
        address recipient,
        uint256 amount
    ) external;

    function increaseAllowance(address spender, uint256 amount) external;

    function decreaseAllowance(address spender, uint256 amount) external;

    event Transfer(address sender, address recipient, uint256 amount);
    event Approval(address owner, address sender, uint256 newAllowance);
    event Mint(address recipient, uint256 amount);
}
