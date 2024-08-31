require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    fhenixHelium: {
      url: "https://api.helium.fhenix.zone",
      accounts: [process.env.PRIVATE_KEY],
      chainId: 8008135
    }
  }
};