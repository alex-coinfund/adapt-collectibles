pragma solidity ^0.4.19;

import {Ownable} from '../zeppelin/contracts/ownership/Ownable.sol';
import {ERC721Token} from '../zeppelin/contracts/token/ERC721/ERC721Token.sol';

contract Collectibles is Ownable, ERC721Token {

	address public adaptAdmin;

	struct TokenMetadata {
		uint32 timestamp;
		uint amount;
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

	function mint(address _to, uint256 _tokenId) public onlyAdmin {
		super._mint(_to, _tokenId);
	}

	function setTokenURI(uint256 _tokenId, string _uri) public onlyAdmin {
		super._setTokenURI(_tokenId, _uri);
	}

	function changeAdmin(address _newAdmin) public onlyOwner {
		adaptAdmin = _newAdmin;
	}

	function setTokenMetadata(uint256 _tokenId, uint32 _timestamp, uint _amount) public canTransfer(_tokenId)  {
		TokenMetadata storage tm = metadata[_tokenId];
		require(tm.timestamp == 0 && tm.amount == 0);
		metadata[_tokenId] = TokenMetadata({timestamp : _timestamp, amount: _amount});
	}

	function getTokenMetadata(uint256 _tokenId) public view returns (uint32 timestamp, uint amount) {
		require(exists(_tokenId));
		TokenMetadata storage tm = metadata[_tokenId];
		return (tm.timestamp, tm.amount);
	}
}
