function accounts(rpc_accounts) {
	return {
		DEPLOY_OPERATOR: rpc_accounts[0],
		ADAPT_OWNER: rpc_accounts[1],
		ADAPT_ADMIN: rpc_accounts[2],
		ADAPT_WALLET: rpc_accounts[3],
		ACCOUNT1: rpc_accounts[4],
		ACCOUNT2: rpc_accounts[5],
	};
}

module.exports = {
	accounts: accounts,
};
