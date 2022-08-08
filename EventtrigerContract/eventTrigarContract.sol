// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "@openzeppelin/contracts/access/Ownable.sol";

 contract Item {
    uint index;
    uint itemPrice;
    SupplyChanManager parentContract;

    constructor(SupplyChanManager _parentContract , uint _itemPrice , uint _index)public  {

        parentContract = _parentContract;
        itemPrice = _itemPrice;
        index = _index;
    }

  
 receive() external payable {
 require(msg.value == itemPrice, "We don't support partial payments");
 require(itemPrice == 0, "Item is already paid!");
 itemPrice += msg.value;
 (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
 require(success, "Delivery did not work");
 }

 fallback () external {

 }

}


contract SupplyChanManager is Ownable{

    // enum for struct 
    enum itemChechStatus{created ,paid , deliverd}

    // item created struct is here 
    struct itemCreatedStruct{
        Item _item ;
        string name ;
        uint amount ;
        uint itemId;
        SupplyChanManager.itemChechStatus _status;
      
    }
   
   
    // struct mapping is here and save in map 
    mapping (uint => itemCreatedStruct) public itemAdd;
    // check how much items i haved 
    uint  itemChecker;
   
    
    // event for supply chain step
    event supplyChainStep(uint _itemChecker , uint _itemStep , address _address);

// item Price convert wei to ether 
    uint private itemPriceConverter = 1000000000000000000 ; 
// itwm created function 
    function itemCreated(string memory _name , uint _amount , uint _itemId )public onlyOwner{
        Item  item = new Item(this , _amount , itemChecker);
        itemAdd[itemChecker]._item = item ;

        itemAdd[itemChecker].name = _name ;
        itemAdd[itemChecker].amount = _amount*itemPriceConverter;
        itemAdd[itemChecker].itemId = _itemId;
        itemAdd[itemChecker]._status = itemChechStatus.created;
        // stepCheck = itemChechStatus.created;
        

        emit supplyChainStep(itemChecker , uint (itemAdd[itemChecker]._status), address(item));
        // itemCreatedStruct.push(_name ,_amount , _itemId ,_itemLimit);
        itemChecker++;
    
    }

// item parchase function here 
    function itemParchase(uint _itemIndex)public payable {

    Item item = itemAdd[_itemIndex]._item;
    require(address(item) == msg.sender, "Only items are allowed to update themselves");
    // require(item.itemPrice == msg.value, "Not fully paid yet");

    require(itemAdd[_itemIndex].amount == msg.value , "please Enter Fixed Amount");
    require(itemAdd[_itemIndex]._status == itemChechStatus.created  , "In this index we Have no Item");
    itemAdd[_itemIndex]._status = itemChechStatus.paid;
    emit supplyChainStep(_itemIndex, uint(itemAdd[_itemIndex]._status), address(item));
 
    
    
    }

//   item Check function here /check where is your item
 
     function itemDeliverd(uint _itemIndex ) public  onlyOwner{
     require(itemAdd[_itemIndex]._status == itemChechStatus.paid , "You have not Order that item first Plz order That");
     itemAdd[_itemIndex]._status = itemChechStatus.deliverd;

      emit supplyChainStep(_itemIndex, uint(itemAdd[_itemIndex]._status), address(itemAdd[_itemIndex]._item));

     }
}