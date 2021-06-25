const {accounts, contract} = require('@openzeppelin/test-environment');
const {expect} = require('chai');
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FundsManagementContract = contract.fromArtifact('FundsManagementContract');

const erc20contractAddr = '0x184fc447d59a3904c88935615af5A6e550EabfDb';

describe('FundsManagementContract', async () => {

    let fundsManagementContract;
    const [sender, receiver1, receiver2, receiver3] = accounts;
    console.log('Sender : ', sender);

    beforeEach(async function () {
        fundsManagementContract = await FundsManagementContract.new(erc20contractAddr, {from: sender});
    });

    it('should set new contract address', async () => {
        const newAddr = '0x2C9101F4E9bAE4A78e7cfa4FeC0f4b5518dea9c1';
        await fundsManagementContract.setNewContract(newAddr);
                                                      
        expect(await fundsManagementContract.erc20Contract()).to.equal(newAddr);
    });

    it('should set new Limit for withdraw', async () => {
        await fundsManagementContract.setNewLimit(2000);
        expect(await fundsManagementContract.limit()).to.equal(2000);
    });

    it('should deposit funds and look at the balance', async () => {
        const val = 1000000000000000000; // 1 bnb in wei
        const currencyEsilliumPrice = 0.01; // 0.01 bnb 
        const tokensCount = (val * (10 * 18)) / (1000000000000000000 * currencyEsilliumPrice);

        await fundsManagementContract.deposit({from: sender, value: val});
        
        expect(await fundsManagementContract.depositFunds()).to.equal(val);
        expect(await fundsManagementContract.balance(erc20contractAddr, {from: sender})).to.equal(tokensCount);
    });

    it('should withdraw funds', async () => {
        const amount = 100;

        const senderBalanceBefore = await fundsManagementContract.balance(erc20contractAddr, {from: sender});
        const receiver1BalanceBefore = await fundsManagementContract.balance(erc20contractAddr, {from: receiver1});

        await fundsManagementContract.withdraw(receiver, amount, {from: sender});

        expect(await fundsManagementContract.balance(erc20contractAddr, {from: sender})).to.equal(senderBalanceBefore - amount);
        expect(await fundsManagementContract.balance(erc20contractAddr, {from: receiver1})).to.equal(receiver1BalanceBefore + amount);
    });

    it('should batch withdraw to addresses', async () => {
        const amounts = 300;
        const receivers = [sender, receiver1, receiver2, receiver3];

        const senderBalanceBefore = await fundsManagementContract.balance(erc20contractAddr, {from: sender});
        const receiverBalance1Before = await fundsManagementContract.balance(erc20contractAddr, {from: receiver1});
        const receiverBalance2Before = await fundsManagementContract.balance(erc20contractAddr, {from: receiver2});
        const receiverBalance3Before = await fundsManagementContract.balance(erc20contractAddr, {from: receiver3});

        await fundsManagementContract.batchWithdraw(receivers, amounts, {from: sender});

        expect(await fundsManagementContract.balance(erc20contractAddr, {from: sender})).to.equal(senderBalanceBefore - amounts);
        expect(await fundsManagementContract.balance(erc20contractAddr, {from: receiver1})).to.equal(receiverBalance1Before + (amounts / 3));
        expect(await fundsManagementContract.balance(erc20contractAddr, {from: receiver2})).to.equal(receiverBalance2Before + (amounts / 3));
        expect(await fundsManagementContract.balance(erc20contractAddr, {from: receiver3})).to.equal(receiverBalance3Before + (amounts / 3));
    });
});
