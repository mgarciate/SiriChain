// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SiriChainGameToken.sol";  // SCG

contract SiriChainGame {
    struct Player {
        uint256 lastClaimTime;
        uint256 rewardBalance;
    }

    SiriChainGameToken public scgToken;
    uint256 public dailyReward = 100 * 10 ** 18; // Reward amount in SCG (with decimals)
    uint256 public claimInterval = 1 minutes;

    mapping(address => Player) public players;

    address owner;

    // Event to log reward claims
    event RewardClaimed(address indexed player, uint256 reward);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor() {
         scgToken = SiriChainGameToken(0xBf5D742F8e07f73796AcC43B96f4E9510B4E864C);
         owner = msg.sender;
    }

    // New player
    function register() external {
        require(players[msg.sender].lastClaimTime == 0, "Player already registered");
        players[msg.sender].lastClaimTime = block.timestamp;
    }

    // Claim daily rewards
    function claimReward() external {
        Player storage player = players[msg.sender];

        require(player.lastClaimTime > 0, "Player not registered");

        // Ensure 24 hours have passed since the last claim
        require(block.timestamp >= player.lastClaimTime + claimInterval, "Claim available every 1 minute");

        uint256 reward = dailyReward;
        player.lastClaimTime = block.timestamp;
        player.rewardBalance += reward;

        scgToken.transfer(msg.sender, reward);

        emit RewardClaimed(msg.sender, reward);
    }

    // Set the daily reward amount
    function setDailyReward(uint256 _dailyReward) external onlyOwner {
        dailyReward = _dailyReward;
    }

    // Function to check the player’s reward balance
    function checkBalance() external view returns (uint256) {
        return players[msg.sender].rewardBalance;
    }
}
