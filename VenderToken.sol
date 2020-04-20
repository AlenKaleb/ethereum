pragma solidity ^0.5.1;

interface CriarToken {
    function approve(address spender, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract VenderToken {
    
    struct Venda {
        uint256 qtd;
        uint256 value;
    }
    
    mapping(address => Venda) vendas;
    uint256 private current;
    
    address public owner;
    
    uint256 public constant QTD_TOKENS = 900000;
    
    bool public aberta; // status atual da venda.
    uint256 dataGravacao;
    
    
    CriarToken criarToken;
    
    constructor() public {
        criarToken = CriarToken(0x9bAB370eA0F50d0c931Be54ECA6B239A8c62A3bd);
        // 0xFCbEEC71A06E3BA109405D01223A5b6A302dfFe2
        owner = address(0xFCbEEC71A06E3BA109405D01223A5b6A302dfFe2);
        aberta = false;
        current = 0;
    }
    
    
    modifier onlyOwner () {
      require(msg.sender == owner);
      _;
    }
    
    function abrirVendas() public {
        require(msg.sender == owner, "Você não tem permissão pra autorizar as vendas de token");
        dataGravacao = block.timestamp;
        aberta = true;
    }
    
    function vender() external payable {
      require(msg.value == precoVenda(), 'Informe 0,1 ether');
      require(QTD_TOKENS > 0, 'Os tokens acabaram!!');
      require(aberta, 'O bolao esta fechado');
      
      if(vendas[msg.sender].qtd == 0) {
          vendas[msg.sender] = Venda({qtd: 1, value: precoVenda()});
      }else {
          vendas[msg.sender] = Venda({qtd: vendas[msg.sender].qtd+1, value: precoVenda()});
      }
     
      criarToken.approve(msg.sender,1);
      criarToken.transfer(msg.sender,1);
     
      current--;
    }
    
    function sacar() external {
        require(f(dataGravacao,60) || current == 0,"Os tokens não acabaram ou não se passaram 2 meses apos a abertura das vendas");
    }
    
    function f(uint start, uint daysAfter) public returns(bool){
        if (now >= start + daysAfter * 1 days) {
            return true;
        }
        return false;
    }
    
    
    function precoVenda() internal pure returns (uint256) {
        return 0.1 ether;
    }
    
    function() external {
        
    }

}
