// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tifa is ERC20 {
    address owner;
    mapping(address => bool) private _blacklist;
    address public treasury;

    constructor() ERC20("Tifa", "TIFA") {
        owner = msg.sender;
        _mint(msg.sender, 1);
    }

    uint public constant TAX = 500;
    function transfer(
        address _to,
        uint _amount
    ) public override returns (bool) {
        require(!_blacklist[_to], "Recipient on the blacklist");
        uint taxAmount = (_amount * TAX) / 10000;
        uint256 remainAmount = _amount - taxAmount;
        _transfer(msg.sender, treasury, taxAmount);
        _transfer(msg.sender, _to, remainAmount);
        return true;
    }

    function mint(address _to, uint _amount) external returns (bool) {
        require(msg.sender == owner, "Invalid Adress!");
        _mint(_to, _amount);
        return true;
    }

    function burn(uint _amount) external returns (bool) {
        require(msg.sender == owner, "Invalid Adress!");
        _burn(msg.sender, _amount);
        return true;
    }

    function addToBlacklist(address _user) external returns (bool) {
        require(
            !_blacklist[_user],
            "The address already exists in the blacklist"
        );
        require(msg.sender == owner, "Invalid Adress!");

        _blacklist[_user] = true;
        return true;
    }

    function removeFromBlacklist(address _user) external returns (bool) {
        require(_blacklist[_user], "The address is not on the blacklist");
        require(msg.sender == owner, "Invalid Adress!");

        _blacklist[_user] = false;
        return true;
    }

    function updateTreasury(address _treasury) external returns (bool) {
        require(_treasury != address(0), "Invalid address!");
        require(msg.sender == owner, "Invalid Adress!");
        treasury = _treasury;
        return true;
    }
}
