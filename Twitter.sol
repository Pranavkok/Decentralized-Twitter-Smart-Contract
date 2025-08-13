// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Twitter{
    uint16 public MAX_TWEET_LENGTH = 280 ;
    struct Tweet{
        address author ;
        string content ;
        uint256 timestamp ;
        uint256 likes ;
    }

    mapping (address => Tweet[])public  tweets ;
    address public owner ;

    constructor(){
        owner = msg.sender ;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"Only owner is allowed ");
        _;
    }

    function changeTweetLength(uint16 _newLength) public onlyOwner{
        MAX_TWEET_LENGTH = _newLength ;
    }

    function createTweet(string memory _tweet) public{
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH , "Maximum character limit exceed !!");

        Tweet memory newTweet = Tweet({
            author : msg.sender ,
            content : _tweet ,
            timestamp : block.timestamp ,
            likes : 0
        });

        tweets[msg.sender].push(newTweet) ;
    }

    function getTweet(uint64 _index) public view returns(Tweet memory){
        return tweets[msg.sender][_index];
    }

    function getAllTweets(address _owner) public view returns(Tweet[] memory){
        return tweets[_owner];
    }

}   
