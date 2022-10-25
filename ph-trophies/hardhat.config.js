require("@nomicfoundation/hardhat-toolbox");
const dotenv = require("dotenv");

dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: "0.8.4",
	networks: {
		"polygon-mumbai": {
			url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.ALCHEMY_POLYGON_MUMBAI_API_KEY}`,
			accounts: [`${process.env.PRIVATE_KEY}`],
		},
	},
	// Set the API keys where the keys are defined by: `npx hardhat verify --list-networks`
	etherscan: {
		apiKey: {
			polygonMumbai: process.env.POLYGONSCAN_API_KEY,
		},
	}};
