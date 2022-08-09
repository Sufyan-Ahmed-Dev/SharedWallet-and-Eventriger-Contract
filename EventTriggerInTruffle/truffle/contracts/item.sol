// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./itemManager.sol";

abstract contract Item {
    uint256 index;
    uint256 itemPrice;
    itemManager parentContract;

constructor(
        itemManager _parentContract,
        uint256 _itemPrice,
        uint256 _index
    )  {
        parentContract = _parentContract;
        itemPrice = _itemPrice;
        index = _index;
    }

    receive() external payable {
        require(msg.value == itemPrice, "We don't support partial payments");
        require(itemPrice == 0, "Item is already paid!");
        itemPrice += msg.value;
        (bool success, ) = address(parentContract).call{value: msg.value}(
            abi.encodeWithSignature("triggerPayment(uint256)", index)
        );
        require(success, "Delivery did not work");
    }

    fallback() external {}
}


