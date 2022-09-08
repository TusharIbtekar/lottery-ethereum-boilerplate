const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');
const util = require('util');

require('dotenv').config();
const mnemonic = process.env.MNEMONIC;
const rinkebyAPI = process.env.API_ENDPOINT;

const provider = new HDWalletProvider(
  mnemonic,
  rinkebyAPI
);
const web3 = new Web3(provider);

const deploy = async() => {
  const accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from ', accounts[0]);

  const result = await new web3.eth.Contract(interface)
    .deploy({ data: bytecode })
    .send({ from: accounts[0], gas: '1000000' });

  console.log('Contract deployed to ', result.options.address);
  console.log(util.inspect(interface, false, null, true));
  provider.engine.stop();
};
deploy();