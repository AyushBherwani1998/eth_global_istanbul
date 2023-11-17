// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface WeeklyChallengeInterface {
    function buyTicket(uint256 _challengeId)
        external;

    function injectFunds(uint256 _challengeId, uint256 _amount) external; 

     function startChallenge(
        uint256 _endTime,
        uint256 _priceTickerInAPE,
        uint256 _treasuryFee
    ) external;

    function viewCurrentChalengeId() external returns (uint256);

    function submitScore(address _scorer, uint256 _score, uint256 _challengeId) external;
}