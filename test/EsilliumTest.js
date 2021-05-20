const {accounts, contract} = require('@openzeppelin/test-environment');
const {expect} = require('chai');
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const ERC20 = contract.fromArtifact('Esillium');

describe('ERC20', function () {

    const [sender, receiver, receiver2, receiver3] = accounts;
    const tokenName = 'BANI';
    const tokenSymbol = 'BANI';
    const owner = sender;
    const totalSupply = 7000000000;
    const decimals = 5;
    console.log('Sender : ', sender);

    beforeEach(async function () {
        // The bundled BN library is the same one web3 uses under the hood
        this.value = new BN(1);

        this.erc20 = await ERC20.new({from: sender});
    });

    it('deployer is owner', async function () {
        expect(await this.erc20.owner()).to.equal(owner);
    });

    it('check contract owner', async function () {
        expect(await this.erc20.owner()).to.equal(owner);
    });

    it('check contract name', async function () {
        expect(await this.erc20.name()).to.equal(tokenName);
    });

    it('check contract totalSupply', async function () {
        let _totalSupply = new BN(totalSupply * 10 ** decimals);
        expect(await this.erc20.totalSupply()).to.be.bignumber.equal(_totalSupply);
    });

    it('check contract symbol', async function () {
        expect(await this.erc20.symbol()).to.equal(tokenSymbol);
    });

    it('reverts when transferring tokens to the zero address', async function () {
        // Conditions that trigger a require statement can be precisely tested

        await expectRevert(
            this.erc20.transfer(constants.ZERO_ADDRESS, this.value, {from: sender}),
            'ERC20: transfer to the zero address.'
        );
    });

//    it('check is paused contract', async function () {
//        expect(await this.erc20.paused()).to.equal(false);
//    });

    it('emits a Transfer event on successful transfers', async function () {
        const receipt = await this.erc20.transfer(
            receiver, this.value, {from: sender}
        );

        // Event assertions can verify that the arguments are the expected ones
        expectEvent(receipt, 'Transfer', {
            from: owner,
            to: receiver,
            value: this.value,
        });
    });

    it('approve the passed address to spend the specified amount', async function () {
        let value = new BN(100);
        let receipt = await this.erc20.approve(receiver, value, {from: sender});
        expectEvent(receipt, 'Approval', {
            tokenOwner: sender,
            spender: receiver,
            value: value
        });
    });

    it('check the amount of tokens that an owner allowed to a spender', async function () {
        let value = new BN(100);
        let receipt = await this.erc20.approve(receiver, value, {from: sender});
        expectEvent(receipt, 'Approval', {
            tokenOwner: sender,
            spender: receiver,
            value: value
        });
        expect(await this.erc20.allowance(owner, receiver)).to.be.bignumber.equal(value);
    });

    it('check balance of sender', async function () {
        expect(await this.erc20.balanceOf(owner))
            .to.be.bignumber.equal(new BN(totalSupply * 10 ** decimals));
    });

    it('updates balances on successful transfers', async function () {
        this.erc20.transfer(receiver, this.value, {from: owner});

        // BN assertions are automatically available via chai-bn (if using Chai)
        expect(await this.erc20.balanceOf(receiver))
            .to.be.bignumber.equal(this.value);
    });

    // it('check start minting', async function () {
    //     let receipt = await this.erc20.startMinting({from: sender});
    //     expectEvent(receipt, 'MintStarted');
    // });
    //
    // it('check minting ability', async function () {
    //     expectRevert(
    //         this.erc20.mint(sender, new BN(10), {from: sender}),
    //         "MintableToken: minting is finished"
    //     );
    // });
    //
    // it('check finishing minting', async function () {
    //     await this.erc20.startMinting({from: sender});
    //     let receipt = await this.erc20.finishMinting({from: sender});
    //     expectEvent(receipt, 'MintFinished');
    // });

    // it('check minting', async function () {
    //     let receipt = await this.erc20.startMinting({from: sender});
    //     expectEvent(receipt, 'MintStarted');
    //     let amount = new BN(1000);
    //     receipt = await this.erc20.mint(sender, amount, {from: sender});
    //     expectEvent(receipt, 'Mint', {
    //         to: sender,
    //         amount: amount
    //     });
    //     expect(await this.erc20.totalSupply()).to.be.bignumber.equal((new BN(totalSupply * 10 ** decimals)).add(amount));
    //     receipt = await this.erc20.finishMinting({from: sender});
    //     expectEvent(receipt, 'MintFinished');
    // });

    // it('check contract pause', async function () {
    //     let receipt = await this.erc20.pause({from: sender});
    //     expectEvent(receipt, 'Pause');
    // });
    //
    // it('unpause contract when it\'s unpaused', async function () {
    //     expectRevert(this.erc20.unpause({from: sender}), "Pausable: contract not paused");
    // });
    //
    // it('pause contract when it paused', async function () {
    //     await this.erc20.pause({from: sender});
    //     expectRevert(this.erc20.pause({from: sender}), "Pausable: contract paused");
    // });
    //
    // it('check contract unpause', async function () {
    //     await this.erc20.pause({from: sender});
    //     let receipt = await this.erc20.unpause({from: sender});
    //     expectEvent(receipt, 'Unpause');
    // });
    //
    // it('transfer to address tokens when it paused', async function () {
    //     await this.erc20.pause({from: sender});
    //     expectRevert(this.erc20.transfer(receiver, new BN(1), {from: sender}), "Pausable: contract paused");
    // });
    //
    // it('transfer tokens from to when it paused', async function () {
    //     await this.erc20.pause({from: sender});
    //     expectRevert(this.erc20.transferFrom(sender, receiver, new BN(1), {from: sender}), "Pausable: contract paused");
    // });

    // it('increase allowance when it paused', async function () {
    //     await this.erc20.pause({from: sender});
    //     expectRevert(this.erc20.increaseAllowance(receiver, new BN(1), {from: sender}), "Pausable: contract paused");
    // });
    //
    // it('approve spender when contract paused', async function () {
    //     await this.erc20.pause({from: sender});
    //     expectRevert(this.erc20.approve(receiver, new BN(1)), "Pausable: contract paused");
    // });

    // it('burn tokens from user account', async function () {
    //     let burnAmount = new BN(100);
    //     let receipt = await this.erc20.burn(burnAmount, {from: sender});
    //     expectEvent(receipt, 'Burn', {
    //         burner: sender,
    //         value: burnAmount
    //     });
    //     expect(await this.erc20.balanceOf(sender)).to.be.bignumber.equal(new BN(totalSupply * 10 ** decimals - 100));
    // });
//
//    it('check account freezing', async function () {
//        let receipt = await this.erc20.freezeAccount(receiver, true, {from: sender});
//        expectEvent(receipt, 'FrozenFunds', {
//            target: receiver,
//            frozen: true
//        });
//    });

    it('test transfer tokens between users', async function () {
        let receipt = await this.erc20.transferFrom(
            sender, receiver, this.value, {from: sender}
        );
        // Event assertions can verify that the arguments are the expected ones
        expectEvent(receipt, 'Transfer', {
            from: owner,
            to: receiver,
            value: this.value,
        });
        expect(await this.erc20.balanceOf(receiver)).to.be.bignumber.equal(this.value);
        expect(await this.erc20.balanceOf(sender)).to.be.bignumber.equal(new BN(totalSupply * 10 ** decimals - 1));
        receipt = await this.erc20.transfer(
            receiver2, this.value, {from: receiver}
        );
        // Event assertions can verify that the arguments are the expected ones
        expectEvent(receipt, 'Transfer', {
            from: receiver,
            to: receiver2,
            value: this.value,
        });
        expect(await this.erc20.balanceOf(receiver2)).to.be.bignumber.equal(this.value);
        expect(await this.erc20.balanceOf(receiver)).to.be.bignumber.equal(new BN(0));

        receipt = await this.erc20.approve(receiver, this.value, { from : receiver2 });
        expectEvent(receipt, 'Approval', {
            tokenOwner: receiver2,
            spender: receiver,
            value: this.value,
        });
        receipt = await this.erc20.transferFrom(
            receiver2, receiver3, this.value, {from: receiver}
        );
        // Event assertions can verify that the arguments are the expected ones
        expectEvent(receipt, 'Transfer', {
            from: receiver2,
            to: receiver3,
            value: this.value,
        });
        expect(await this.erc20.balanceOf(receiver3)).to.be.bignumber.equal(this.value);
        expect(await this.erc20.balanceOf(receiver2)).to.be.bignumber.equal(new BN(0));

    });

    it('check increasing allowances', async function () {
        let receipt = await this.erc20.approve(receiver, this.value, { from : receiver2 });
        expectEvent(receipt, 'Approval', {
            tokenOwner: receiver2,
            spender: receiver,
            value: this.value,
        });
        receipt = await this.erc20.increaseAllowance(receiver, this.value, { from : receiver2 });
        expectEvent(receipt, 'Approval', {
            tokenOwner: receiver2,
            spender: receiver,
            value: new BN(2),
        });

        receipt = await this.erc20.decreaseAllowance(receiver, this.value, { from : receiver2 });
        expectEvent(receipt, 'Approval', {
            tokenOwner: receiver2,
            spender: receiver,
            value: new BN(1),
        });
    });

    // it('burn tokens from users account', async function () {
    //     let burnAmount = new BN(100);
    //     let receipt = await this.erc20.burn(burnAmount, {from: sender});
    //     expectEvent(receipt, 'Burn', {
    //         burner: sender,
    //         value: burnAmount
    //     });
    //     expect(await this.erc20.balanceOf(sender)).to.be.bignumber.equal(new BN(totalSupply * 10 ** decimals - 100));
    //     receipt = await this.erc20.transfer(
    //         receiver2, this.value, {from: sender}
    //     );
    //     // Event assertions can verify that the arguments are the expected ones
    //     expectEvent(receipt, 'Transfer', {
    //         from: sender,
    //         to: receiver2,
    //         value: this.value,
    //     });
    //     expect(await this.erc20.balanceOf(receiver2)).to.be.bignumber.equal(this.value);
    //     receipt = await this.erc20.burn(this.value, {from: receiver2});
    //     expectEvent(receipt, 'Burn', {
    //         burner: receiver2,
    //         value: this.value
    //     });
    //     expect(await this.erc20.balanceOf(receiver2)).to.be.bignumber.equal(new BN(0));
    //     receipt = await this.erc20.transfer(
    //         receiver3, this.value, {from: sender}
    //     );
    //     // Event assertions can verify that the arguments are the expected ones
    //     expectEvent(receipt, 'Transfer', {
    //         from: sender,
    //         to: receiver3,
    //         value: this.value,
    //     });
    //     expectRevert(this.erc20.burnFrom(receiver3, this.value, {from: receiver2}),
    //         'ERC20: account allowed balance is lower than amount');
    //
    //     receipt = await this.erc20.increaseAllowance(receiver2, this.value, { from : receiver3 });
    //     expectEvent(receipt, 'Approval', {
    //         tokenOwner: receiver3,
    //         spender: receiver2,
    //         value: new BN(1),
    //     });
    //     receipt = await this.erc20.burnFrom(receiver3, this.value, {from: receiver2});
    //     expectEvent(receipt, 'Burn', {
    //         burner: receiver3,
    //         value: this.value
    //     });
    //     expectEvent(receipt, 'Approval', {
    //         tokenOwner: receiver3,
    //         spender: receiver2,
    //         value: new BN(0),
    //     });
    // });

    // it('check add new tokens', async function () {
    //     let receipt = await this.erc20.startMinting({from: sender});
    //     expectEvent(receipt, 'MintStarted');
    //     let amount = new BN(1000);
    //     receipt = await this.erc20.addTokens(amount, {from: sender});
    //     expectEvent(receipt, 'Mint', {
    //         to: sender,
    //         amount: amount
    //     });
    //     receipt = this.erc20.addTokens(amount, {from: receiver2});
    //     expectRevert(receipt, "MintableToken: sender has not permissions");
    //     expect(await this.erc20.totalSupply()).to.be.bignumber.equal((new BN(totalSupply * 10 ** decimals)).add(amount));
    //     receipt = await this.erc20.finishMinting({from: sender});
    //     expectEvent(receipt, 'MintFinished');
    // });

    // it('Check buy tokens', async function () {
    //     expect(await this.erc20.getBoughtTokensByCurrentPrice()).to.be.bignumber.equal(new BN(0));
    //     expect(await this.erc20.getBuyTokensLimit()).to.be.bignumber.equal(new BN(totalSupply * 10 ** decimals));
    //
    //     let receipt = await this.erc20.setPrices(totalSupply * 10 ** decimals, {from: sender});
    //
    //     expectEvent(receipt, 'SetNewPrice');
    //
    //     // Check buying tokens
    //
    //
    //     receipt = await this.erc20.sendTransaction({from: receiver, value: 1000000000000000000});
    //
    //     expectEvent(receipt, 'Buy');
    //
    //     let tokensAmount = await this.erc20.calculateBuyTokens(new BN(1000000000000000000).toString());
    //
    //     console.log(tokensAmount);
    //     expect(await this.erc20.getBoughtTokensByCurrentPrice()).to.be.bignumber.equal(new BN(0));
    //
    // });
});
