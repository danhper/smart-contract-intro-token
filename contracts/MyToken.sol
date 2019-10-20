pragma solidity ^0.5.0;


contract MyToken {
  uint256 constant supply = 1000000;
  mapping (address => uint256) balances;
  mapping (address => mapping(address => uint256)) allowances;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  constructor() public {
    balances[msg.sender] = supply;
  }

  function totalSupply() public pure returns (uint256) {
    return supply;
  }

  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

  function executeTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
    balances[_from] -= _value;
    balances[_to] += _value;
    emit Transfer(_from, _to, _value);
    return true;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(balances[msg.sender] >= _value, "balance too low");
    return executeTransfer(msg.sender, _to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(balances[_from] >= _value, "balance too low");
    require(_from == msg.sender || allowances[_from][_to] >= _value, "insufficient allowance");
    allowances[_from][_to] -= _value;
    return executeTransfer(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowances[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowances[_owner][_spender];
  }
}
