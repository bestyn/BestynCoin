const {accounts, contract} = require('@openzeppelin/test-environment');
const {expect} = require('chai');
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FundsManagementContract = contract.fromArtifact('FundsManagementContract');
const ERC20 = contract.fromArtifact('Esillium');

// const erc20contractAddr = '0x184fc447d59a3904c88935615af5A6e550EabfDb'; // bsc test

describe('FundsManagementContract', async () => {

    let fundsManagementContract;
    let erc20;
    let erc20contractAddress;

    const [sender, receiver1, receiver2, receiver3] = accounts;
    console.log('Sender : ', sender); 

    beforeEach(async () => {
        erc20 = await ERC20.new({from: sender});
        erc20contractAddress = erc20.address;

        fundsManagementContract = await FundsManagementContract.new(erc20contractAddress, {from: sender});
    });

    xit('should set new contract address', async () => {
        const newAddress = '';
        await fundsManagementContract.setNewContract(newAddr, {from: sender});
                                                      
        expect(await fundsManagementContract.erc20Contract()).to.equal(newAddr);
    });

    xit('should set new Limit for withdraw', async () => {
        const newLimit = new BN(2000)
        await fundsManagementContract.setNewLimit(newLimit, {from: sender});
        expect(await fundsManagementContract.limit()).to.be.bignumber.equal(newLimit);
    });

    it('should deposit funds and look at the balance', async () => {
        const val = new BN(1000000000000000); // 0.0001 bnb in wei
        const currencyEsilliumPrice = new BN(10000000000000); // 0.00001 bnb in wei
        const tokensCount = val / currencyEsilliumPrice; 

        await fundsManagementContract.deposit({from: sender, value: val});
        expect(await fundsManagementContract.owner()).to.be.bignumber.equal(val);
        expect(await fundsManagementContract.balance(erc20contractAddress, {from: sender})).to.be.bignumber.equal(tokensCount);
    });

    xit('should withdraw funds', async () => {
        const amount = 100;

        const senderBalanceBefore = await fundsManagementContract.balance({from: sender});
        const receiver1BalanceBefore = await fundsManagementContract.balance({from: receiver1});

        await fundsManagementContract.withdraw(receiver, amount, {from: sender});

        expect(await fundsManagementContract.balance({from: sender})).to.equal(senderBalanceBefore - amount);
        expect(await fundsManagementContract.balance({from: receiver1})).to.equal(receiver1BalanceBefore + amount);
    });

    xit('should batch withdraw to addresses', async () => {
        const amounts = 300;
        const receivers = [sender, receiver1, receiver2, receiver3];

        const senderBalanceBefore = await fundsManagementContract.balance({from: sender});
        const receiverBalance1Before = await fundsManagementContract.balance({from: receiver1});
        const receiverBalance2Before = await fundsManagementContract.balance({from: receiver2});
        const receiverBalance3Before = await fundsManagementContract.balance({from: receiver3});

        await fundsManagementContract.batchWithdraw(receivers, amounts, {from: sender});

        expect(await fundsManagementContract.balance({from: sender})).to.equal(senderBalanceBefore - amounts);
        expect(await fundsManagementContract.balance({from: receiver1})).to.equal(receiverBalance1Before + (amounts / 3));
        expect(await fundsManagementContract.balance({from: receiver2})).to.equal(receiverBalance2Before + (amounts / 3));
        expect(await fundsManagementContract.balance({from: receiver3})).to.equal(receiverBalance3Before + (amounts / 3));
    });
});




