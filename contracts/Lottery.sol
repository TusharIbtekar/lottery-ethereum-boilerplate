// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Lottery {
  address public manager;
  address public winner;
  address payable[] public players;

  constructor() {
    manager = msg.sender;
  }

  function enter() public payable {
    require(msg.value >= 0.00001 ether);
    players.push(payable(msg.sender));
  }

  function random() private view returns(uint) {
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
  }

  function pickWinner() public {
    uint index = random() % players.length;
    winner = players[index];
    players[index].transfer(address(this).balance);
    players = new address payable[](0);
  }

  modifier managerRestricted() {
    require(msg.sender == manager);
    _;
  }

  function getPlayers() public view returns(address payable[] memory) {
    return players;
  }

  function getBalance() public view returns(uint) {
    return address(this).balance;
  }
}