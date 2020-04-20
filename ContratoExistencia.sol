pragma solidity ^0.5.1;

contract ContratoExistencia {
    
    string private hash;
    
    uint256 private dataGravacao;
    
    constructor() public {
        dataGravacao = block.timestamp;
        hash = "9ba17fec2b3f1ecd3bb613fd11556d4aa63e9ab7";
    }
    
}
