pragma solidity ^0.4.21;
contract PostcardContract {


    struct Postcard{
        string  username;
        string  content;
        string  ip;
        string  timestamp;
    }
    Postcard[]  public cards;

    address manager;

    modifier onlymanager(){
        require(msg.sender==manager);
        _;
    }

    function PostcardContract(){
        manager=msg.sender;
    }

    function countCards() public view onlymanager returns(uint){
        return cards.length;
    }

    function sendCard(string username, string content, string ip, string timestamp) public onlymanager {
        Postcard memory card=Postcard({
           username: username,
           content: content,
           ip: ip,
           timestamp: timestamp
        });
        cards.push(card);
    }

    function openCard() public view onlymanager returns(string,string, string, string){
        uint index=random()%cards.length;
        return (cards[index].username, cards[index].content, cards[index].ip, cards[index].timestamp);
    }

    function random() private view returns (uint) {
        //sha3 is also a global function
        //block is global variable that we can access any time
        //now is also global
        return uint(keccak256(block.difficulty, now, cards));
    }
}
