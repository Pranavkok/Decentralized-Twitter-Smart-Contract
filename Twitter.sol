// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IProfile{
    struct user{
        string username;
        string bio;
    }

     function getProfile(address _user) external view returns ( user memory);
    
}

contract Twitter{
    uint16 public MAX_TWEET_LENGTH = 280 ;
    struct Tweet{
        uint256 id ;
        address author ;
        string content ;
        uint256 timestamp ;
        uint256 likes ;
    }

    event TweetCreated (uint256 id , address author , string content , uint256 timestamp);
    event TweetLiked (address liker , address tweetAuthor , uint256 tweetId , uint256 likesCount);
    event TweetUnLiked (address unliker , address tweetAuthor , uint256 tweetId , uint256 likesCount);

    mapping (address => Tweet[])public  tweets ;
    address public owner ;
    IProfile profileContract ;

    constructor(address _profileContract){
        owner = msg.sender ;
        profileContract = IProfile(_profileContract) ;
    }

    modifier onlyRegistered(){
        IProfile.user memory userProfTemp = profileContract.getProfile(msg.sender);
        require(bytes(userProfTemp.username).length > 0, "User Not Registered");
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner,"Only owner is allowed ");
        _;
    }

    function changeTweetLength(uint16 _newLength) public onlyOwner{
        MAX_TWEET_LENGTH = _newLength ;
    }

    function createTweet(string memory _tweet) public onlyRegistered{
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH , "Maximum character limit exceed !!");

        Tweet memory newTweet = Tweet({
            id : tweets[msg.sender].length,
            author : msg.sender ,
            content : _tweet ,
            timestamp : block.timestamp ,
            likes : 0
        });

        tweets[msg.sender].push(newTweet) ;
        emit TweetCreated(newTweet.id, msg.sender, _tweet, block.timestamp);
    }

    function likeTweet(address _owner , uint256 _index) external onlyRegistered{
        require(tweets[_owner][_index].id == _index, "No Tweet Found"); 
        tweets[_owner][_index].likes++ ;
        emit TweetLiked(msg.sender, _owner, _index, tweets[_owner][_index].likes);
    }

    function unlikeTweet(address _owner , uint256 _index) external onlyRegistered{
        require(tweets[_owner][_index].id == _index, "No Tweet Found"); 
        require(tweets[_owner][_index].likes > 0 , "This tweet already have zero likes"); 
        tweets[_owner][_index].likes-- ;
        emit TweetUnLiked(msg.sender, _owner, _index, tweets[_owner][_index].likes);
    }

    function getTweet(uint64 _index) public view returns(Tweet memory){
        return tweets[msg.sender][_index];
    }

    function getAllTweets(address _owner) public view returns(Tweet[] memory){
        return tweets[_owner];
    }

    function getTotalLikes(address _author) external view returns(uint256){
        uint256 TotalLikes = 0;
        for(uint256 i=0 ; i < tweets[_author].length ; i++){
            TotalLikes += tweets[_author][i].likes ;
        }
        return TotalLikes ;
    }

}   
