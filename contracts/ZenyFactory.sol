pragma solidity ^0.4.19;

import "./Zeny.sol";

contract ZenyFactory {
  mapping (address => address[]) public created;
  mapping (address => bool) public isZeny;
  bytes public ZenyByteCode;

  function ZenyFactory() public {
    address verifiedToken = createZeny(10000, "Zeny", 3, "ZNY");
    ZenyByteCode = codeAt(verifiedToken);
  }

  function verifyZeny(address _tokenContract) public view returns (bool) {
    bytes memory fetchedTokenByteCode = codeAt(_tokenContract);
    if (fetchedTokenByteCode.length != ZenyByteCode.length) {
      return false;
    }

    for (uint i = 0; i < fetchedTokenByteCode.length; i++) {
      if (fetchedTokenByteCode[i] != ZenyByteCode[i]) {
        return false;
      }
    }

    return true;
  }

  function createZeny(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol) public returns (address) {
    Zeny newToken = (new Zeny(_initialAmount, _name, _symbol, _decimals));
    created[msg.sender].push(address(newToken));
    isZeny[address(newToken)] = true;
    newToken.transfer(msg.sender, _initialAmount);
    return address(newToken);
  }

  // Retrieves the bytecode at a specific address.
  function codeAt(address _addr) internal view returns (bytes outputCode) {
    assembly {
      // Retrieve the size of the code.
      let size := extcodesize(_addr)

      // Allocate output byte array.
      outputCode := mload(0x40)

      // New memory end includes padding.
      mstore(0x40, add(outputCode, and(add(add(size, 0x20), 0x1f), not(0x1f))))

      // Store length in memory.
      mstore(outputCode, size)

      // Retrieve the code.
      extcodecopy(_addr, add(outputCode, 0x20), 0, size)
    }
  }
}

