pragma solidity ^0.5.1;

interface Oraculo {
    function winner() external returns (uint256);
}

contract Bolao {
    
    struct Jogada {
        address payable hashAddress;
        uint256 time;
        uint256 value;
    }
    
    address public owner;
    
    uint256 public constant QTD_JOGADAS = 9; // começa no zero
    
    uint256 public current; // apostas que estão em andamento
    uint256 public timeVencedor; // time vencedor
    
    bool public aberto; // status atual do bolao aberto ou não.
    
    Oraculo oraculo;
    
    Jogada[] public jogadas; // Apostas realizadas
    Jogada[] public vencedores; // Apostas vencedoras
    
    constructor() public {
        oraculo = Oraculo(0x0C29a9D0b1Dda8Db92b8eE117A0b313297AA7Da0);
        aberto = true;
        current = 0;
    }
    
    /*
        Recupera o total apostado do endereço especifico.
        Caso seja reembolso recupera o total de IesbEther e seta 0 IesbEther a cada reembolso
    */
    function findJogadorByHashAddress(bool reembolso) internal returns(uint256){
        uint256 totalApostado = 0;
        for(uint i = 0; i < jogadas.length; i++){
            if(jogadas[i].hashAddress == msg.sender){
                totalApostado += jogadas[i].value;
                if(reembolso){
                    jogadas[i].value = 0;
                }
            }
        }
        return totalApostado;
    }
    
    modifier onlyOwner () {
      require(msg.sender == owner);
      _;
    }
    
    function apostar(uint256 _time) public payable {
      require(msg.value == umEther(), 'Informe 1 ether');
      require(current <= QTD_JOGADAS, 'Limite de apostas e 10');
      require(_time == 1 || _time == 2, 'Escolha time 1 ou time 2');
      require(aberto, 'O bolao esta fechado');
      
      Jogada memory a = Jogada({hashAddress: msg.sender, time: _time, value: msg.value});
      jogadas.push(a);
      
      current++;
    }
    
    function reembolsar() external {
        uint256 total = findJogadorByHashAddress(true);
        require(total != 0, "Endereco não tem aposta no bolao");
        msg.sender.transfer(total);
    }
    
    function encerrar() external {
        //require(!aberto == true, "Bolão não esta aberto!");
        uint256 qtdVencedores = 0;
        timeVencedor = oraculo.winner();
        for(uint256 i = 0; i < jogadas.length; i++){
            if(jogadas[i].time == timeVencedor){
                Jogada memory jogo = jogadas[i];
                vencedores.push(jogo);
                qtdVencedores++;
            }
        }
        
        uint256 premio = uint(address(this).balance) / uint(qtdVencedores);
        
        for(uint256 i = 0; i < qtdVencedores; i++){
            vencedores[i].hashAddress.transfer(premio);
        }
        aberto = false;
    }
    
    
    function umEther() internal pure returns (uint256) {
        return 1000000000000000000;
    }
    
    function() external {
        
    }

}
