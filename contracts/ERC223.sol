pragma solidity ^0.4.19;

contract ERC223 {
  function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
  function transfer(address _to, uint256 _value, bytes _data, string _fallback) public returns (bool success);
  event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes indexed _data);
}

