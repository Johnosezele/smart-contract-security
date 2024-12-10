// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract SecureBank is ReentrancyGuard, Ownable, Pausable {
    mapping(address => uint256) public balances;
    
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event EmergencyWithdrawn(address indexed by, uint256 amount);

    // Secure deposit function with events
    function deposit() public payable whenNotPaused {
        require(msg.value > 0, "Amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
    
    // Secure withdraw with reentrancy guard and checks-effects-interactions pattern
    function withdraw(uint256 amount) public nonReentrant whenNotPaused {
        require(amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        // Update state before external call
        balances[msg.sender] -= amount;
        
        // External call after state update
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawn(msg.sender, amount);
    }
    
    // Secure emergency withdraw with access control
    function emergencyWithdraw() public onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Transfer failed");
        
        emit EmergencyWithdrawn(msg.sender, balance);
    }
    
    // Pause contract in emergency
    function pause() public onlyOwner {
        _pause();
    }
    
    // Unpause contract
    function unpause() public onlyOwner {
        _unpause();
    }
    
    // Get contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // Required to receive ETH
    receive() external payable {
        revert("Direct deposits not allowed");
    }
}
