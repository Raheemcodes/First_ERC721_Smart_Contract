import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('NFT', () => {
  const DEFAULT_ADDRESS = '0x0000000000000000000000000000000000000000';
  const Role = {
    Default: 0,
    Admin: 1,
    Mint: 2,
  };

  const deployContract = async () => {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount, anotherAccount] = await ethers.getSigners();

    const MyTestToken = await ethers.getContractFactory('CustomRole');
    const instance = await MyTestToken.deploy();
    await instance.waitForDeployment();

    return { instance, owner, otherAccount, anotherAccount };
  };

  describe('deployment', () => {
    it('should grant deployer ADMIN_ROLE', async () => {
      const { instance, owner } = await loadFixture(deployContract);

      const isAdmin: boolean = await instance.hasRole(
        owner.address,
        Role.Admin
      );

      expect(isAdmin).to.be.true;
    });
  });

  describe('ADMIN', () => {
    it('should be able to MINT', async () => {
      const { instance, owner } = await loadFixture(deployContract);

      await expect(instance.connect(owner).safeMint())
        .to.emit(instance, 'Transfer')
        .withArgs(DEFAULT_ADDRESS, owner.address, 0);
    });

    it('should be able to grant MINT role', async () => {
      const { instance, otherAccount } = await loadFixture(deployContract);

      await instance.grantMintRole(otherAccount);
      const isMinter = await instance.hasRole(otherAccount, Role.Mint);

      expect(isMinter).to.be.true;
    });

    it('should be able to revoke MINT role', async () => {
      const { instance, otherAccount } = await loadFixture(deployContract);

      await instance.grantMintRole(otherAccount);
      await instance.revokeMintRole(otherAccount);

      const isMinter = await instance.hasRole(otherAccount, Role.Mint);

      expect(isMinter).to.be.false;
    });

    it('should be able to grant ADMIN role', async () => {
      const { instance, otherAccount } = await loadFixture(deployContract);

      await instance.grantRole(otherAccount, Role.Admin);
      const isAdmin: boolean = await instance.hasRole(
        otherAccount.address,
        Role.Admin
      );

      expect(isAdmin).to.be.true;
    });

    it('should be able to revoke ADMIN role', async () => {
      const { instance, otherAccount } = await loadFixture(deployContract);

      await instance.grantRole(otherAccount, Role.Admin);
      await instance.revokeRole(otherAccount);

      const isAdmin = await instance.hasRole(otherAccount, Role.Admin);

      expect(isAdmin).to.be.false;
    });

    it("shouldn't be able to grant roles if not an ADMIN", async () => {
      const { instance, otherAccount, anotherAccount } = await loadFixture(
        deployContract
      );

      await expect(instance.connect(otherAccount).grantMintRole(anotherAccount))
        .to.be.reverted;
    });
  });

  describe('MINT', () => {
    it('should be able mint if account has MINT role', async () => {
      const { instance, otherAccount } = await loadFixture(deployContract);
      await instance.grantMintRole(otherAccount);

      await expect(instance.connect(otherAccount).safeMint())
        .to.emit(instance, 'Transfer')
        .withArgs(DEFAULT_ADDRESS, otherAccount.address, 0);
    });

    it("shouldn't be able to mint if account doesn't have mint role", async () => {
      const { instance, otherAccount } = await loadFixture(deployContract);

      await expect(instance.connect(otherAccount).safeMint()).to.be.reverted;
    });

    it('should not be able to MINT if totalSuppy 3', async () => {
      const { instance, otherAccount } = await loadFixture(deployContract);

      await instance.grantMintRole(otherAccount);
      await instance.connect(otherAccount).safeMint();
      await instance.connect(otherAccount).safeMint();
      await instance.connect(otherAccount).safeMint();

      await expect(instance.connect(otherAccount).safeMint()).to.be.reverted;
    });
  });
});
