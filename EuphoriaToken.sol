// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EuphoriaTest is ERC20 ,Ownable{
    uint256 public giveawayTokensSupply = 400;
    uint256 public givawayTokensMinted;
    uint256 public maxSupply;
    bool public paused = true;
    mapping(address => bool) controllers;

    constructor() ERC20("EuphoriaTest", "EuphTest"){}
    
    function giveAwayTokens(address to, uint256 amount) public onlyOwner {
        require(givawayTokensMinted != giveawayTokensSupply, "Giveaway token supply mints exceeded");
        _mint(to, amount);
        givawayTokensMinted +=amount;
    }
    function mint(address to, uint256 amount) external {
        require(!paused, "Contract is Paused");
        require(controllers[msg.sender], "Only controllers can mint");
        _mint(to, amount);
    }
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
    function addController(address controller) external onlyOwner {
        controllers[controller] = true;
    }

    function removeController(address controller) external onlyOwner {
        controllers[controller] = false;
    }
    function setMaxSupplu(uint256 _maxSupply) public onlyOwner{
        maxSupply = _maxSupply;
    }
    function pause() public onlyOwner {
        paused = !paused;
    }
}