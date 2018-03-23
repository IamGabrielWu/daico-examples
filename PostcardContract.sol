pragma solidity ^0.4.21;
pragma experimental ABIEncoderV2;

//enable experimental ABIEncoderV2 for return type as struct
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

    function openCard() public view onlymanager returns(Postcard){
        uint index=random()%cards.length;
        return cards[index];
    }

    function random() private view returns (uint) {
        //sha3 is also a global function
        //block is global variable that we can access any time
        //now is also global
        // keccak256 doesn't support struct type https://ethereum.stackexchange.com/questions/40151/solidity-unimplementedfeatureerror-only-in-memory-reference-type-can-be-stored
        return uint(keccak256(block.difficulty, now, cards.length));
    }
}
