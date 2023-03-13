pragma solidity ^0.8.0;

contract game{

    address owner;
    address winner;
    uint256 public bet;
    address participants;
    bool existGame= false;


    event GameCreated(address creator,uint gameNumber);
    event GameStarted(address[] participants, uint gameNumber);



    constructor(){
        owner = msg.sender;
    }

    function CreateGame(address participant) public payable{
        require(msg.value>0,"not enough ether");
        bet = msg.value;
        participants = participant;
        existGame = true;

    }

    function joinGame() public payable{
        require(msg.sender == participants,"you are not a participant.");
        require(msg.value >= bet, "your bet must be equal or higuer to the existing one.");
        if(msg.value>bet){
            uint balance = msg.value - bet;
            (bool sent,) = payable(msg.sender).call{value:balance}("");
            require(sent, "transaction failed");
            bet = bet * 2;
        }

    } 

}

