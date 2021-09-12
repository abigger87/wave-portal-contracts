// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint256 totalWaves;
  mapping(address => uint256) wave_mapping;

  /// @notice a private seed for pseudo random number generation
  uint256 private seed;

  /// @notice a mapping to store the user's last wave
  mapping(address => uint256) public lastWaved;

  /// @notice Magical event to show when someone waves
  event NewWave(address indexed from, uint256 timestamp, string message);

  /// @notice A Wave struct to store waves!
  struct Wave {
    address waver;
    string message;
    uint256 timestamp;
  }

  /// @notice Store a list of waves
  Wave[] waves;

  constructor() payable {
    console.log("WavePortal Constructed!");
  }

  /// @notice wave to me!
  /// @param _message the string message for the given Wave
  function wave(string memory _message) public {
    // make sure the user can't wave more than once every 20 seconds
    require(lastWaved[msg.sender] + 20 seconds < block.timestamp, "You can only wave once every 20 seconds!");

    lastWaved[msg.sender] = block.timestamp;

    totalWaves += 1;
    wave_mapping[msg.sender] += 1;
    console.log("%s just waved with message %s", msg.sender, _message);

    waves.push(Wave(msg.sender, _message, block.timestamp));

    // Generate a pseudo random number in the range 100
    uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
    console.log("Random number generated: %s", randomNumber);

    // Set the seed for the next round
    seed = randomNumber;

    // Now we want to send a prize if we are 50% probable
    if (randomNumber < 50) {
      console.log("%s won!", msg.sender);
      uint256 prizeAmount = 0.0001 ether;
      require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has!");
      (bool success,) = (msg.sender).call{value: prizeAmount}("");
      require(success, "Failed to withdraw money :((");
    }

    emit NewWave(msg.sender, block.timestamp, _message);
  }

  /// @notice returns all waves
  function getAllWaves() view public returns (Wave[] memory) {
    return waves;
  }

  /// @notice returns the total wave count
  function getTotalWaves() view public returns (uint256) {
    console.log("We have %d total waves.", totalWaves);
    return totalWaves;
  }

  /// @notice fetches all waves for a given user (msg.sender)
  function getMyWaves() view public returns (uint256) {
    console.log("%s has waved %d times!", msg.sender, wave_mapping[msg.sender]);
    return wave_mapping[msg.sender];
  }
}