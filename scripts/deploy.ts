import { ethers } from 'hardhat';

(async () => {
  try {
    const nft = await ethers.deployContract('CustomRole');
    await nft.waitForDeployment();

    console.log(`Deployed at ${await nft.getAddress()}`);
  } catch (err) {
    console.error(err);
    process.exitCode = 1;
  }
})();
