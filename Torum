// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Torum is ERC20, Ownable {
    constructor(address initialOwner) ERC20("Torum Token", "XTM") Ownable(initialOwner) {
        _mint(initialOwner, 1_000_000_000_000 * 1e18);
    }
}
