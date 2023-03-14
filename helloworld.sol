pragma solidity ^0.8.0;

contract game{

    address owner;
    address winner;
    uint256 public bet;
    bool existGame= false;
    uint256 private count = 0;
    
    mapping(uint => address[])mapp;
    event GameCreated(address creator,uint gameNumber);
    event GameStarted(address[] participants, uint gameNumber);



    constructor(){
        owner = msg.sender;
    }

    function createGame(address participant) public payable{
        require(msg.value>0,"not enough ether");
        bet = msg.value;
        mapp[count].push(msg.sender);
        mapp[count].push(participant);
        existGame = true;
        emit GameCreated(msg.sender,count);
        count++;

    }

    function joinGame(uint gameNumber) public payable{
        require(mapp[gameNumber][1] == msg.sender,"you are not a participant.");
        require(msg.value >= bet, "your bet must be equal or higuer to the existing one.");
        if(msg.value>bet){
            uint balance = msg.value - bet;
            (bool sent,) = payable(msg.sender).call{value:balance}("");
            require(sent, "transaction failed");
            bet = bet * 2;
        }else{
            bet+=msg.value;
        }
        emit GameStarted(mapp[gameNumber], gameNumber);


    } 

    function makeMove(uint move, uint gameNumber) public payable{

    }

}

