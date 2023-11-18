// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

/// Address 0x039C2a957fD82C9FF27e29BB6ef4aeb13e5EA4Dd
contract ApeCoin is ERC20, Ownable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("APE COIN", "APE")
        Ownable(initialOwner)
        ERC20Permit("APE COIN")
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
