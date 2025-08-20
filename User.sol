// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Profile{
    struct user{
        string username ;
        string bio ;
    }

    mapping(address => user)internal profiles ;

    function setProfile(string memory _username , string memory _bio)public{
        profiles[msg.sender] = user(_username , _bio) ;
    }

    function getProfile(address _user) public view returns ( user memory){
        return profiles[_user];
    }

}
