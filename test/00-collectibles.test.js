require('babel-register');
require('babel-polyfill');

import EVMRevert from "../zeppelin/test/helpers/EVMRevert";
import {accounts} from './common/common';
const Collectibles = artifacts.require("../contracts/Collectibles.sol");

let Promise = require('bluebird');
const BigNumber = web3.BigNumber;
let chai = require('chai');
let assert = require('chai').assert;
const should = require('chai')
	.use(require('chai-as-promised'))
	.use(require('chai-bignumber')(BigNumber))
	.should();


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

	it('should let adapt admin to mint tokens', async function () {
		await collectibles.mint(ac.ACCOUNT1, 0, 0, 'uri0', {from: ac.ADAPT_ADMIN, gas: 7000000}).should.be.fulfilled;
		let uri = await collectibles.tokenURI(0);
		assert.equal(uri, 'uri0', 'unexpected token uri');

		await collectibles.mint(ac.ACCOUNT1, 1, 0, 'uri1', {from: ac.ADAPT_ADMIN, gas: 7000000}).should.be.fulfilled;
		uri = await collectibles.tokenURI(1);
		assert.equal(uri, 'uri1', 'unexpected token uri');

		// duplicate token id  - expect reject
		await collectibles.mint(ac.ACCOUNT1, 1, 0, 'uri', {from: ac.ADAPT_ADMIN, gas: 7000000}).should.be.rejectedWith(EVMRevert);

		let balance = await collectibles.balanceOf(ac.ACCOUNT1);

		assert.equal(balance, 2, 'unexpected balance');
	});

	it('should let token owner to set token metadata', async function () {
		await collectibles.setTokenMetadata(0, 10000, 1, 1, {from: ac.ACCOUNT1, gas: 7000000}).should.be.fulfilled;
		let metadata = await collectibles.getTokenMetadata(0);
		assert.equal(metadata[0], 10000, 'unexpected timestamp');
		assert.equal(metadata[1], 1, 'unexpected amount');
	});

	it('should let the owner to mass mint 10 copies of the very same token', async function () {
		let jsonHash = web3.sha3("pic", "title", "description").slice(2);
		let uri = 'https://adaptk.it/j/' + jsonHash;
		console.log('uri: ', uri);
		let result = await collectibles.massMint(ac.ADAPT_ADMIN, jsonHash, 0, 10, uri,
			{from: ac.ADAPT_ADMIN, gas: 7000000}).should.be.fulfilled;
		console.log('gas: ', result.receipt.gasUsed);

		let balance = await collectibles.balanceOf(ac.ADAPT_ADMIN);
		assert.equal(balance, 10, 'unexpected balance');
	});

	it('should let the owner to mass mint 10 more copies of the very same token', async function () {
		let jsonHash = web3.sha3("pic", "title", "description").slice(2);
		let uri = 'https://adaptk.it/j/' + jsonHash;
		console.log('uri: ', uri);

		let result = await collectibles.massMintTolerant(ac.ACCOUNT2, jsonHash, 5, 10, uri,
			{from: ac.ADAPT_ADMIN, gas: 7000000}).should.be.fulfilled;

		console.log('gas: ', result.receipt.gasUsed);

		let balance = await collectibles.balanceOf(ac.ACCOUNT2);
		assert.equal(balance, 5, 'unexpected balance');
	});
});
