// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@fhenixprotocol/contracts/FHE.sol";
import "@fhenixprotocol/contracts/access/Permissioned.sol";

contract NomoPrivateTransfer is Permissioned {
    // Mapping of encrypted balances
    mapping(address => euint32) private _encBalances;

    /// Deposit ETH and convert to encrypted balance
    function deposit() public payable {
        euint32 amount = FHE.asEuint32(uint32(msg.value));
        _encBalances[msg.sender] = _encBalances[msg.sender] + amount;
    }

    /// Transfer encrypted ETH to another address
    /// @param to The recipient's address
    /// @param encryptedAmount The encrypted amount of ETH to transfer
    function transferEncrypted(address to, inEuint32 calldata encryptedAmount) public {
        euint32 amount = FHE.asEuint32(encryptedAmount);
        FHE.req(amount.lte(_encBalances[msg.sender]));
        _encBalances[to] = _encBalances[to] + amount;
        _encBalances[msg.sender] = _encBalances[msg.sender] - amount;
    }

    /// Withdraw ETH from encrypted balance
    function withdraw(inEuint32 memory amount) public {
        euint32 _amount = FHE.asEuint32(amount);
        FHE.req(_encBalances[msg.sender].gte(_amount));
        _encBalances[msg.sender] = _encBalances[msg.sender] - _amount;
        payable(msg.sender).transfer(FHE.decrypt(_amount));
    }

    /// @return The decrypted balance of the sender
    /// Permission parameter and onlySender modifier ensure that only the account owner can decrypt and view their balance.
    function getBalanceEncrypted(Permission calldata perm) public view onlySender(perm) returns (uint256) {
        return FHE.decrypt(_encBalances[msg.sender]);
    }
}
