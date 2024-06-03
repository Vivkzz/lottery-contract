// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

/**
 * @title A Raffle Contract
 * @author Vivek Tanna
 * @notice Jsu ta sample contract to create a lottery
 * @dev Using Chainlink VRF and Chainlink Automation
 */

// just use /** */ and it will pop up
contract Raffle {
    error Raffle_NotEnoughEthSent();

    uint64 private constant REQUEST_CONFIRMAATION = 3;
    uint64 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    address private immutable i_vrfcoordinator;
    bytes32 private immutable i_keyhash;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    event EnteredRaffle(address indexed player);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfcoordinator,
        bytes32 keyhash
    ) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfcoordinator = vrfcoordinator;
        i_keyhash = keyhash;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not Enough ETH sent");

        // both are doing same task but below one is efficient
        if (msg.value < i_entranceFee) {
            revert Raffle_NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));

        emit EnteredRaffle(msg.sender);
    }

    function pickWinner() external {
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }
        uint256 requestId = i_vrfcoordinator.requestRandomWords(
            i_keyhash,
            i_subscriptionId,
            REQUEST_CONFIRMAATION,
            i_callbackGasLimit,
            NUM_WORDS
        );
    }

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
