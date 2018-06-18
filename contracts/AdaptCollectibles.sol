pragma solidity ^0.4.23;

import {ERC721Token} from '../zeppelin/contracts/token/ERC721/ERC721Token.sol';
import {Ownable} from '../zeppelin/contracts/ownership/Ownable.sol';

contract AdaptCollectibles is ERC721Token, Ownable {

	address public adaptAdmin;

	struct TokenMetadata {
		uint timestamp;
		uint donation;
		uint copy;
	}

	// Optional mapping for token metadata
	mapping(uint => TokenMetadata) internal metadata;

	constructor(
		address _adaptOwner,
		address _adaptAdmin) public
		ERC721Token("AdaptThankYou", "ADPT") {

		adaptAdmin = _adaptAdmin;
		transferOwnership(_adaptOwner);
	}

	modifier onlyAdmin() {
		require(msg.sender == adaptAdmin);
		_;
	}

	function mint(address _to, string _jsonHash, uint _copy) public onlyAdmin {
		uint tokenId = uint(keccak256(abi.encodePacked(_jsonHash, _copy)));
		super._mint(_to, tokenId);
		super._setTokenURI(tokenId, _jsonHash);
		metadata[tokenId].copy = _copy;
	}

	function massMint(
		address _to,
		string _jsonHash,      // sha3(pic, title, description)
		uint _copyStart,
		uint _copiesCount
	) public onlyAdmin {

		require(_copiesCount <= 10);

		uint copyEnd = _copyStart + _copiesCount;
		for (uint copy = _copyStart; copy < copyEnd; copy++) {
			uint tokenId = uint(keccak256(abi.encodePacked(_jsonHash, copy)));

			// skip tokens minted already
			if(exists(tokenId))
				continue;

			super._mint(_to, tokenId);
			super._setTokenURI(tokenId, _jsonHash);
			metadata[tokenId].copy = copy;
		}
	}


	function setTokenURI(uint _tokenId, string _uri) public onlyAdmin {
		super._setTokenURI(_tokenId, _uri);
	}

	function changeAdmin(address _newAdmin) public onlyOwner {
		adaptAdmin = _newAdmin;
	}

	function setTokenMetadata(uint _tokenId, uint _timestamp, uint _donation) public canTransfer(_tokenId)  {
		TokenMetadata storage tm = metadata[_tokenId];

		// this can be done once only
		require(tm.timestamp == 0 && tm.donation == 0);

		// update the metadata structure
		metadata[_tokenId].timestamp = _timestamp;
		metadata[_tokenId].donation = _donation;
	}

	function getTokenMetadata(uint _tokenId) public view
		returns (
			uint timestamp,
			uint donation,
			uint copy) {

		require(exists(_tokenId));
		TokenMetadata storage tm = metadata[_tokenId];
		return (
			tm.timestamp,
			tm.donation,
			tm.copy
		);
	}
}
