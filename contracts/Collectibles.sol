pragma solidity ^0.4.19;

import {Ownable} from '../zeppelin/contracts/ownership/Ownable.sol';
import {ERC721Token} from '../zeppelin/contracts/token/ERC721/ERC721Token.sol';

contract Collectibles is Ownable, ERC721Token {

	address public adaptAdmin;

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

	function mint(address _to, uint256 _tokenId) onlyAdmin public {
		super._mint(_to, _tokenId);
	}

	function setTokenURI(uint256 _tokenId, string _uri) onlyAdmin public {
		super._setTokenURI(_tokenId, _uri);
	}

	function changeAdmin(address _newAdmin) public onlyOwner {
		adaptAdmin = _newAdmin;
	}
}
