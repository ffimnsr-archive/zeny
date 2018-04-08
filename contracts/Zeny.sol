pragma solidity ^0.4.19;

import "./ERC20.sol";
import "./ERC223.sol";
import "./ZenyReceivingContract.sol";

contract Zeny is ERC20, ERC223 {
  uint256 constant private MAX_UINT256 = 2**256 - 1;
  mapping (address => uint256) public balances;
  mapping (address => mapping (address => uint256)) public allowed;

  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 internal supply;

  function Zeny(
    uint256 _supply,
    string _name,
    string _symbol,
    uint8 _decimals
  ) public {
    balances[msg.sender] = _supply;
    supply = _supply;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }

  // Total number of tokens in existence.
  function totalSupply() public constant returns (uint256) {
    return supply;
  }

  // Transfer token for a specified address.
  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(_value <= balances[msg.sender]);
    balances[msg.sender] -= _value;
    balances[_to] += _value;

    Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] -= _value;
    balances[_to] += _value;

    if (allowed[_from][msg.sender] < MAX_UINT256) {
      allowed[_from][msg.sender] -= _value;
    }

    Transfer(_from, _to, _value);
    return true;
  }

  // Gets the balance of the specified address.
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  // Approve the passed address to spend the specified amount of tokens on behalf of
  // msg.sender.
  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;

    Approval(msg.sender, _spender, _value);
    return true;
  }

  // Check the amount of tokens that an owner allowed to a spender.
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }
}
