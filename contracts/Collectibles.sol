pragma solidity ^0.4.19;

import {Ownable} from '../zeppelin/contracts/ownership/Ownable.sol';

contract Collectibles is Ownable {

	address public adaptAdmin;

	function Collectibles(
		address _adaptOwner,
		address _adaptAdmin) public {

		adaptAdmin = _adaptAdmin;
		transferOwnership(_adaptOwner);
	}
}
