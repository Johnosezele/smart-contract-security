// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        balances[msg.sender] += msg.value;
    }
    
    // Vulnerable function - Reentrancy attack possible
    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(address(this).balance >= amount, "Contract has insufficient balance");
        
        // Send ETH before updating the balance (vulnerable to reentrancy)
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        // Update balance after transfer (vulnerable)
        balances[msg.sender] -= amount;
    }
    
    // Vulnerable timestamp dependency
    function isLuckyDay() public view returns (bool) {
        return (block.timestamp % 15 == 0);
    }
    
    // Unprotected function
    function emergencyWithdraw() public {
        uint256 amount = address(this).balance;
        require(amount > 0, "No balance to withdraw");
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    // Required to receive ETH
    receive() external payable {}
}
