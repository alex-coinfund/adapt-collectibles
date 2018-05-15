pragma solidity ^0.4.19;

import {Ownable} from '../zeppelin/contracts/ownership/Ownable.sol';
import {ERC721Token} from '../zeppelin/contracts/token/ERC721/ERC721Token.sol';

contract Collectibles is Ownable, ERC721Token {

	address public adaptAdmin;

	struct TokenMetadata {
		uint32 timestamp;
		uint amount;
		string currency;
		uint copy;
	}

	// Optional mapping for token metadata
	mapping(uint256 => TokenMetadata) internal metadata;

	function Collectibles(
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

	function mint(address _to, string _jsonHash, uint _copy, string _uri) public onlyAdmin {
		uint tokenId = uint(keccak256(_jsonHash, _copy));
		super._mint(_to, tokenId);

		// TODO: shall we concatenate uri with _jsonHash?
		super._setTokenURI(tokenId, _uri);
		metadata[tokenId].copy = _copy;
	}

	function massMint(
		address _to,
		string _jsonHash,      // sha3(pic, title, description)
		uint _copyStart,
		uint _copies,
		string _uri
	) public onlyAdmin {

		require(_copies <= 10);

		uint copy_end = _copyStart + _copies;
		for (uint copy = _copyStart; copy < copy_end; copy++) {
			mint(_to, _jsonHash, copy, _uri);
		}
	}

	function massMintTolerant(
		address _to,
		string _jsonHash,      // sha3(pic, title, description)
		uint _copyStart,
		uint _copies,
		string _uri
	) public onlyAdmin {

		require(_copies <= 10);

		uint copy_end = _copyStart + _copies;
		for (uint copy = _copyStart; copy < copy_end; copy++) {
			uint tokenId = uint(keccak256(_jsonHash, copy));

			// skip tokens minted already
			if(exists(tokenId))
				continue;

			mint(_to, tokenId, copy, _uri);
		}
	}


	function setTokenURI(uint256 _tokenId, string _uri) public onlyAdmin {
		super._setTokenURI(_tokenId, _uri);
	}

	function changeAdmin(address _newAdmin) public onlyOwner {
		adaptAdmin = _newAdmin;
	}

	function setTokenMetadata(uint256 _tokenId, uint32 _timestamp, uint _amount, string _currency) public canTransfer(_tokenId)  {
		TokenMetadata storage tm = metadata[_tokenId];

		// this can be done once only
		require(tm.timestamp == 0 && tm.amount == 0);

		// update the metadata structure
		metadata[_tokenId].timestamp = _timestamp;
		metadata[_tokenId].amount = _amount;
		metadata[_tokenId].currency = _currency;
	}

	function getTokenMetadata(uint256 _tokenId) public view returns (uint32 timestamp, uint amount) {
		require(exists(_tokenId));
		TokenMetadata storage tm = metadata[_tokenId];
		return (tm.timestamp, tm.amount);
	}
}
