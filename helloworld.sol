pragma solidity ^0.8.0;

contract game{

    address owner;
    address winner;
    bool existGame= false;
    uint256 private count = 0;
    
    mapping(uint => address[])mapp;
    mapping(uint => uint) moveMap;
    mapping(address => uint) moveStorage;
    mapping(uint256 => uint256) gameBets;

    event GameCreated(address creator,uint gameNumber);
    event GameStarted(address[] participants, uint gameNumber);
    event GameComplete(address winner, uint gameNumber);


    constructor(){
        owner = msg.sender;
    }

    function createGame(address participant) public payable{
        require(msg.value>0,"not enough ether");
        mapp[count].push(msg.sender);
        mapp[count].push(participant);
        existGame = true;
        gameBets[count] = msg.value;
        emit GameCreated(msg.sender,count);

        count++;

    }

    function joinGame(uint gameNumber) public payable{
        require(mapp[gameNumber][1] == msg.sender,"you are not a participant.");
        uint bet = gameBets[gameNumber];
        require(msg.value >= bet, "your bet must be equal or higuer to the existing one.");
        if(msg.value>bet){
            uint balance = msg.value - bet;
            (bool sent,) = payable(msg.sender).call{value:balance}("");
            require(sent, "transaction failed");
            bet = bet * 2;
            gameBets[gameNumber] = bet;
        }else{
            bet+=msg.value;
        }
        emit GameStarted(mapp[gameNumber], gameNumber);


    } 

    function makeMove(uint move, uint gameNumber) public payable{
        require(move <=3,"Move not allowed");
        if(moveMap[gameNumber] ==0){
            moveStorage[msg.sender] = move;
            moveMap[gameNumber]++;
        }else{
            moveStorage[msg.sender] = move;
        }
        uint256 bet = gameBets[gameNumber];
        address participant_1 = mapp[gameNumber][0];
        address participant_2 = mapp[gameNumber][1];

        if(moveStorage[participant_1] == moveStorage[participant_2]){
            emit GameComplete(address(0), gameNumber);
            (bool sent,) = payable(participant_1).call{value:bet/2}("");
            require(sent,"transaction failed");
            (bool sent2,) = payable(participant_2).call{value:bet/2}("");
            require(sent2,"transaction failed");
        }else if(moveStorage[participant_1]==1){
            if(moveStorage[participant_2]== 2){
                winnerAux(participant_2, gameNumber, bet);
            }else{
                winnerAux(participant_1, gameNumber, bet);
            }
        }else if(moveStorage[participant_1] == 2){
            if(moveStorage[participant_2] == 3){
                winnerAux(participant_2, gameNumber, bet);
            }else{
                winnerAux(participant_1, gameNumber, bet);
            }
        }else if(moveStorage[participant_1] == 3){
            if(moveStorage[participant_2]==1){
                winnerAux(participant_2, gameNumber, bet);
            }else{
                winnerAux(participant_1, gameNumber, bet);
            }
        }

    }


    function winnerAux(address winner, uint gameNumber,uint bet) private {
        emit GameComplete(winner ,gameNumber);
        (bool sent,) = payable(winner).call{value:bet}("");
        require(sent,"transaction failed");
    }

}

