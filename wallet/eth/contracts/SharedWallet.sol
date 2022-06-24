// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";


contract SharedWallet is Ownable{

    event LimitChanged (address indexed _member, uint _oldLimit, uint _newLimit);

    
  struct MembersStruct {
    string name;
    uint limit;
    bool is_admin;
  }

    mapping(address => MembersStruct) internal members;

    function getLimit(address _address) external view returns( string memory, uint, bool){
        return   (members[_address].name, members[_address].limit, members[_address].is_admin);
    }

    

    function  addMembers(address _address, string memory _name, uint _newLimit, bool _isAdmin) public onlyOwner{
        uint _oldLimit = members[_address].limit;
        members[_address].name = _name;
        members[_address].limit = _newLimit;
        members[_address].is_admin = _isAdmin;


        emit LimitChanged (_address, _oldLimit, _newLimit);
    }

    function deleteMamber(address _address) public onlyOwner{
        delete members[_address];
    }

    function ownerOrMember( uint _amount) internal view returns(bool){
       return members[_msgSender()].limit >= _amount || isOwner() || members[_msgSender()].is_admin == true;
       
    }

    function isOwner() internal view returns(bool){
        return owner() == _msgSender();
    }

    function deduceMoney(uint _amount) internal {
        members[_msgSender()].limit -= _amount;
    }

    function renounceOwnership() public view override onlyOwner {
       revert("this function is block");
    }

    function makeAdmin(address _address) external onlyOwner {
        members[_address].is_admin = true;
    }

    function revokeAdmin(address _address) external onlyOwner{
        members[_address].is_admin = false;
    }


}