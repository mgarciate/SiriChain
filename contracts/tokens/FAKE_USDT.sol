// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDT is ERC20{
    constructor() ERC20("Tether USD", "USDT"){}

    function issueToken(address receiver, uint256 amount) public{
        _mint(receiver, amount);
    }
}
