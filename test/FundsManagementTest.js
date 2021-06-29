const {accounts, contract} = require('@openzeppelin/test-environment');
const {expect} = require('chai');
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FundsManagementContract = contract.fromArtifact('FundsManagementContract');
const ERC20 = contract.fromArtifact('BaniContract');

// const erc20contractAddr = '0x184fc447d59a3904c88935615af5A6e550EabfDb'; // bsc test

describe('FundsManagementContract', async () => {

    let fundsManagementContract;
    let erc20;
    let erc20contractAddress;

    const [sender, receiver1, receiver2, receiver3, receiver4] = accounts;
    console.log('Sender : ', sender);

    /// Token data

        const totalSupply = 7000000000;
        const decimals = 5;

    beforeEach(async () => {
        erc20 = await ERC20.new({from: sender});
        erc20contractAddress = erc20.address;
        fundsManagementContract = await FundsManagementContract.new(erc20contractAddress, {from: sender});

        await erc20.approve(fundsManagementContract.address, totalSupply * 10 ** decimals, {from : sender}); /// @fix Added approve for transfer tokens
    });

    it('should set new contract address', async () => {
        const newAddress = await ERC20.new({from: receiver4});

        await fundsManagementContract.setNewContract(newAddress.address, {from: sender});
                                                      
        expect(await fundsManagementContract.erc20Contract()).to.equal(newAddress.address);
    });

    it('should set new Limit for withdraw', async () => {
        const newLimit = new BN(2000)
        await fundsManagementContract.setNewLimit(newLimit, {from: sender});
        expect(await fundsManagementContract.limit()).to.be.bignumber.equal(newLimit);
    });

    it('should deposit funds and look at the balance', async () => {
        const val = new BN(1000000000000000); // 0.0001 bnb in wei
        const currencyEsilliumPrice = new BN(10000000000000); // 0.00001 bnb in wei
        const tokensCount = val.div(currencyEsilliumPrice);

        expect(await fundsManagementContract.owner()).to.equal(sender); /// @fix Incorrect check owner address
        expect(await fundsManagementContract.balance()).to.be.bignumber.equal(String(totalSupply * 10 ** decimals)); // @fix Check count approved tokens
        expect(await fundsManagementContract.balanceOf(sender)).to.be.bignumber.equal(String(totalSupply * 10 ** decimals)); // @fix Check count approved tokens
        await fundsManagementContract.deposit({from: receiver4, value: val});
        expect(await fundsManagementContract.balanceOf(receiver4)).to.be.bignumber.equal(tokensCount); // @fix Check count approved tokens
    });

    it('should withdraw funds', async () => {
        const amount = 100;

        const senderBalanceBefore = await fundsManagementContract.balanceOf(sender);
        const receiver1BalanceBefore = await fundsManagementContract.balanceOf(receiver1);

        await fundsManagementContract.withdraw(receiver1, amount, {from: sender});

        expect(await fundsManagementContract.balanceOf(sender)).to.bignumber.equal(String(senderBalanceBefore - amount));
        expect(await fundsManagementContract.balanceOf(receiver1)).to.bignumber.equal(String(receiver1BalanceBefore + amount));
    });

    it('should batch withdraw to addresses', async () => {
        const amounts = [400, 200, 100,100];
        const receivers = [sender, receiver1, receiver2, receiver3];

        const senderBalanceBefore = await fundsManagementContract.balanceOf(sender);
        const receiverBalance1Before = await fundsManagementContract.balanceOf(receiver1);
        const receiverBalance2Before = await fundsManagementContract.balanceOf(receiver2);
        const receiverBalance3Before = await fundsManagementContract.balanceOf(receiver3);

        await fundsManagementContract.batchWithdraw(receivers, amounts, {from: sender});

        expect(await fundsManagementContract.balanceOf(sender)).to.bignumber.equal(String(senderBalanceBefore - amounts[0]));
        expect(await fundsManagementContract.balanceOf(receiver1)).to.bignumber.equal(String(amounts[1]));
        expect(await fundsManagementContract.balanceOf(receiver2)).to.bignumber.equal(String(amounts[2]));
        expect(await fundsManagementContract.balanceOf(receiver3)).to.bignumber.equal(String(amounts[3]));
    });
});




