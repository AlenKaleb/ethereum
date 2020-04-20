pragma solidity ^0.4.24;

import "./IERC20.sol";
import "./SafeMath.sol";

/**
 * @title Criar Token
 *
 */
contract CriarToken is IERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;

  uint256 private _totalSupply;
  
  address private _hashAddressProfessor;
  address private _hashAddressPrimeiroMembro;
  address private _hashAddressSegundoMembro;
  address private _hashAddressTerceiroMembro;
  
  constructor() public {
      _hashAddressProfessor = address(0x7fc07ef1c1e6e7939d9d56f717e3c4ce7e9aafd1);
      _hashAddressPrimeiroMembro = address(0x10d35Aa9f7F9D1A432D66C37185bc1B6AA058d69);
      _hashAddressSegundoMembro = address(0x7501893df4D55E898F62a16E3D66cFDBc2773f0e);
      _hashAddressTerceiroMembro = address(0xbD20bA9ec7C7639D2d791743147bCabe41e1F86F);
      _balances[_hashAddressProfessor] = 1000;
      _balances[_hashAddressPrimeiroMembro] = 33000;
      _balances[_hashAddressSegundoMembro] = 33000;
      _balances[_hashAddressTerceiroMembro] = 33000;
      _totalSupply = 1000000;
  }


  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }


  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }


  function allowance(
    address owner,
    address spender
   )
    public
    view
    returns (uint256)
  {
    return _allowed[owner][spender];
  }
  

  function transfer(address to, uint256 value) public returns (bool) {
    require(value <= _balances[msg.sender]);
    require(to != address(0));

    _balances[msg.sender] = _balances[msg.sender].sub(value);
    _balances[to] = _balances[to].add(value);
    emit Transfer(msg.sender, to, value);
    return true;
  }


  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }


  function transferFrom(
    address from,
    address to,
    uint256 value
  )
    public
    returns (bool)
  {
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    emit Transfer(from, to, value);
    return true;
  }


  function increaseAllowance(
    address spender,
    uint256 addedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }


  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }


  function _mint(address account, uint256 amount) internal {
    require(account != 0);
    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }


  function _burn(address account, uint256 amount) internal {
    require(account != 0);
    require(amount <= _balances[account]);

    _totalSupply = _totalSupply.sub(amount);
    _balances[account] = _balances[account].sub(amount);
    emit Transfer(account, address(0), amount);
  }


  function _burnFrom(address account, uint256 amount) internal {
    require(amount <= _allowed[account][msg.sender]);

    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
      amount);
    _burn(account, amount);
  }
  
  function() external {
        
  }
}
