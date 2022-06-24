// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

 import "./SharedWallet.sol";

contract Wallet is SharedWallet{
    event MoneyWithdraw (address indexed _to, uint _amount);
    event MoneyReceived (address indexed _from, uint _amount);
    

    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
    fallback() external payable {}

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function withdrawManey(uint _amount) public {
        require(ownerOrMember(_amount), "not possible!");
        if(!isOwner() && members[_msgSender()].is_admin == false) { deduceMoney(_amount); }
        payable(msg.sender).transfer(_amount);

        emit MoneyWithdraw (msg.sender, _amount);
    }
}