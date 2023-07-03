import { ethers } from 'hardhat';

(async () => {
  try {
    const nft = await ethers.deployContract('NFT');
    await nft.waitForDeployment();
  } catch (err) {
    console.error(err);
    process.exitCode = 1;
  }
})();
