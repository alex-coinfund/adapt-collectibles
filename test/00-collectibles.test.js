require('babel-register');
require('babel-polyfill');

import EVMRevert from "../zeppelin/test/helpers/EVMRevert";
import {accounts} from './common/common';

let chai = require('chai');
let assert = chai.assert;
let Promise = require('bluebird');

const Collectibles = artifacts.require("../contracts/Collectibles.sol");

contract('Collectibles', function (rpc_accounts) {

	let ac = accounts(rpc_accounts);

	let pGetBalance = Promise.promisify(web3.eth.getBalance);
	let pSendTransaction = Promise.promisify(web3.eth.sendTransaction);

	let collectibles = null;

	it('should be able to deploy the Collectibles contract and set initial state', async function () {
		collectibles = await Collectibles.new(
			ac.ADAPT_OWNER,
			ac.ADAPT_ADMIN,
			{from: ac.DEPLOY_OPERATOR, gas: 7000000}
		);

		console.log("collectibles.address= " +collectibles.address);
	});

});
