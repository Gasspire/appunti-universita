//SPDIX 
contract DecentralizedTris is DecentralizedTrisSpecs{

    struct Partita{
        address p1;
        address p2;
        uint256 bet;
        Mark[9] mosse;
        GameState stato;
        address curr_turn;
    }
    

    uint num_partite;
    mapping(uint => Partita) partite;

    modifier OnlyExisting(uint id){
        if(id >= num_partite) revert InvalidGame();
        _;
    }

    modifier OnlyTurn(uint id){
        if(msg.sender != partite[id].curr_turn) revert NotYourTurn(); 
        _;
    }
    


    function createGame() external payable returns (uint gameId){}

    // Unisciti a una partita in attesa versando l'esatta quota
    function joinGame(uint gameId) external payable{}

    // Fai una mossa specificando la cella (da 0 a 8)
    function makeMove(uint gameId, uint8 position) external{}

    // --- Metodi di sola lettura ---
    function getGameState(uint gameId) external view returns (GameState){
        return partite[gameId].stato;
    }
    function getBoard(uint gameId) external view returns (Mark[9] memory){
        return partite[gameId].mosse;
    }
    function getCurrentTurn(uint gameId) external view returns (address){
        return partite[gameId].curr_turn;
    }


}