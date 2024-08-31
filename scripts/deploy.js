const hre = require("hardhat");

async function main() {
  const NomoPrivateTransfer = await hre.ethers.getContractFactory("NomoPrivateTransfer");
  const nomoPrivateTransfer = await NomoPrivateTransfer.deploy();

  console.log("NomoPrivateTransfer deployed to:", await nomoPrivateTransfer.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});