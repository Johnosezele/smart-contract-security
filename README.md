# Smart Contract Security Analysis

This project demonstrates common smart contract vulnerabilities and how to identify them.

## Vulnerabilities in VulnerableBank.sol

1. **Reentrancy Attack**
   - Location: `withdraw()` function
   - Issue: State changes occur after external call
   - Risk: Attacker can recursively call withdraw() before balance is updated

2. **Timestamp Manipulation**
   - Location: `isLuckyDay()` function
   - Issue: Relies on block.timestamp
   - Risk: Miners can slightly manipulate timestamps

3. **Access Control**
   - Location: `emergencyWithdraw()` function
   - Issue: No access control
   - Risk: Anyone can drain the contract

4. **Integer Arithmetic**
   - Location: `deposit()` function
   - Issue: Potential for overflow in older Solidity versions
   - Note: Safe in Solidity 0.8.0+ due to built-in overflow checks

## How to Audit

1. Manual Review:
   - Check state changes ordering
   - Look for missing access controls
   - Review arithmetic operations
   - Examine external calls

2. Automated Tools:
   - Slither
   - Mythril
   - Echidna

3. Testing:
   - Write exploit POCs
   - Fuzz testing
   - Invariant testing
