// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "@openzeppelin/contracts/access/Ownable.sol";
contract AllowanceContract is Ownable{

    constructor()public{
        Owner =msg.sender;
    }
    modifier OwnerAllowed(uint _amount){ 
      require(Owner == msg.sender || Allowance[msg.sender] >= _amount , "You are not owner");
        _;
    }

    mapping(address => uint) public Allowance ;
    address public Owner;

   event AllowanceChanged(address indexed _toWho , address indexed _fromWho , uint oldAmount , uint _newAmount);


    function AddAllowance(address _whichUser , uint _amount)public onlyOwner{
        emit AllowanceChanged (_whichUser , msg.sender , Allowance[_whichUser] , _amount);
        _amount = _amount*1000000000000000000;
        Allowance[_whichUser] =_amount ;
        
    }
    // reduce Allowance
    function reduceAllowance(address _whichUser , uint _amount)internal {
        emit AllowanceChanged (_whichUser , msg.sender , Allowance[_whichUser] , Allowance[_whichUser] - _amount);
        Allowance[_whichUser] -= _amount;
    }
}
contract sharedWallet is AllowanceContract{
    // renonce function overwrite 
    function renounceOwnership()public override pure {
        revert("This functionality doesnot work in this smart Contract");
    }
    // tranferMOney Function

    event MoneySend(address indexed _to , uint _amount);
    event MoneyReceived(address indexed _from  , uint _amount);

    //  contract balance 
    function TransferMoney()public payable {
        emit MoneyReceived(msg.sender , msg.value);
    }

    // withdraw money to other Account
    function withDrawMoney(address payable _to , uint _amount)public OwnerAllowed(_amount){
        require(_amount <= address(this).balance);
        if(Owner != msg.sender){
            reduceAllowance(msg.sender , _amount);
        }

        emit MoneySend(_to , _amount);
        _amount = _amount*1000000000000000000;
        _to.transfer(_amount);
    }
} 