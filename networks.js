const {secret, mnemonic} = require('./secrets.js');
const PrivateKeyProvider = require("truffle-privatekey-provider");
const HDWalletProvider = require('truffle-hdwallet-provider');

module.exports = {
    networks: {
        development: {
            protocol: 'http',
            host: 'localhost',
            port: 8545,
            gas: 6700000,
            gasPrice: 5e9,
            networkId: '*',
        },
        ropsten: {
            provider: () => new HDWalletProvider(mnemonic, "https://ledger.orderbook.fun/MLW2HyDB2CULJMnZUteeELsPDJPJewCZyNLqwn53cbyR6LaXww/"),
            networkId: 3,       // Ropsten's id
            gas: 6700000,
            gasPrice: 5e9,
        },
        rinkeby: {
            provider: () => new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/b63bffeec2e545f2a3e9b3e9423d6180"),
            networkId: 4,       // Rinkeby id
            gas: 6700000,
            gasPrice: 5e9,
        },
        main: {
            provider: () => new HDWalletProvider(mnemonic, "https://mainnet.infura.io/v3/e2cf25c109ed45b8a24dc6b531210625"),
            networkId: 1,       // Mainnet id
            gas: 6700000,
            gasPrice: 5e9,
        },
        bsctest: {
            provider: () => new PrivateKeyProvider(secret, "https://data-seed-prebsc-1-s1.binance.org:8545/"),
            networkId: 97,       // Binance Smart Chain Testnet id
            gas: 6700000,
            gasPrice: 5e9,
        }
    },
};
