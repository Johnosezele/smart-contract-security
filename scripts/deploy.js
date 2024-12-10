const hre = require("hardhat");

async function main() {
  // Deploy VulnerableBank
  const VulnerableBank = await hre.ethers.getContractFactory("VulnerableBank");
  const vulnerableBank = await VulnerableBank.deploy();
  await vulnerableBank.deployed();
  console.log("VulnerableBank deployed to:", vulnerableBank.address);

  // Deploy SecureBank
  const SecureBank = await hre.ethers.getContractFactory("SecureBank");
  const secureBank = await SecureBank.deploy();
  await secureBank.deployed();
  console.log("SecureBank deployed to:", secureBank.address);

  // Deploy AttackerContract
  const AttackerContract = await hre.ethers.getContractFactory("AttackerContract");
  const attacker = await AttackerContract.deploy(vulnerableBank.address);
  await attacker.deployed();
  console.log("AttackerContract deployed to:", attacker.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
