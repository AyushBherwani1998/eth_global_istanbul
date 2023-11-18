// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";
import "./interfaces/IWeeklyChallenge.sol";

/// Deployed at 0x083B91A0d157b65B9778b023b18ad92Ed7007Ea1
contract WeeklyChallenge is WeeklyChallengeInterface, Ownable, AutomationCompatibleInterface {
    using SafeERC20 for IERC20;

    address public injectorAddress;
    address public operatorAddress;
    address public treasuryAddress;

    uint256 public constant MAX_INTERVAL = 7 days;

    uint256 public currentChallengeId;
    uint256 public pendingInjectionNextChallenge;
    uint256 public constant MAX_TREASURY_FEE = 3000;
    uint256 public currentTicketId;
    uint256 public pendingInjectionNextLottery;

    IERC20 public apeCoin;

    uint256 public lastTimeStamp;

    enum Status {
        Pending,
        Open,
        Close
    }

     struct Challenge {
        Status status;
        uint256 startTime;
        uint256 endTime;
        uint256 priceTicketInAPE;
        uint256 treasuryFee; // 500: 5% // 200: 2% // 50: 0.5%
        uint256 amountCollectedInAPE;
        uint256 highScore;
        address highScorer;
    }

     mapping(uint256 => Challenge) private _challenges;
     mapping(uint256 => mapping(address => uint256[])) private _scores;

    mapping(address => mapping(uint256 => uint256))
        private _userTicketIdPerChallenge;

      modifier notContract() {
        require(!_isContract(msg.sender), "Contract not allowed");
        require(msg.sender == tx.origin, "Proxy contract not allowed");
        _;
    }

    modifier onlyOperator() {
        require(msg.sender == operatorAddress, "Not operator");
        _;
    }

    modifier onlyOwnerOrInjector() {
        require(
            (msg.sender == owner()) || (msg.sender == injectorAddress),
            "Not owner or injector"
        );
        _;
    }

     constructor(address _apeCoinTokenAddress, address originalOwner) Ownable(originalOwner) {
        apeCoin = IERC20(_apeCoinTokenAddress);
    }

     function buyTicket(uint256 _challengeId)
        external
        override
        notContract
    {
        require(
            _challenges[_challengeId].status == Status.Open,
            "Challenge is not open"
        );
        require(
            block.timestamp < _challenges[_challengeId].endTime,
            "Challenge is over"
        );


        // Calculate number of FilDex to be transfered to this contract
        uint256 amountApeCoinToTransfer = _challenges[_challengeId]
            .priceTicketInAPE;

        // Transfer APE Coin tokens to this contract
        apeCoin.safeTransferFrom(
            address(msg.sender),
            address(this),
            amountApeCoinToTransfer
        );

        // Increment the total amount collected for the Challenge round
        _challenges[_challengeId].amountCollectedInAPE += amountApeCoinToTransfer;
        
        // Increase Challenge ticket number
        currentTicketId++;
        _userTicketIdPerChallenge[msg.sender][_challengeId] = currentTicketId;
    }

     function startChallenge(
        uint256 _interval,
        uint256 _priceTickerInAPE,
        uint256 _treasuryFee
    ) external override onlyOperator {
        require(
        _interval < MAX_INTERVAL,
            "Challenge length outside of range"
        );

        require(_treasuryFee <= MAX_TREASURY_FEE, "Treasury fee too high");

        currentChallengeId++;

        _challenges[currentChallengeId] = Challenge({
            status: Status.Open,
            startTime: block.timestamp,
            endTime: block.timestamp + _interval,
            priceTicketInAPE: _priceTickerInAPE,
            treasuryFee: _treasuryFee,
            amountCollectedInAPE: pendingInjectionNextLottery,
            highScore: 0,
            highScorer: address(0)
        });

        pendingInjectionNextLottery = 0;
    }

    function submitScore(address _scorer, uint256 _score, uint256 _challengeId) external override onlyOperator {
        require(_userTicketIdPerChallenge[_scorer][_challengeId] > 0, "User has not bought the ticket");
        _scores[_challengeId][_scorer].push(_score);
        bool isHighScore = _challenges[_challengeId].highScore < _score;
        if(isHighScore) {
            _challenges[_challengeId].highScore = _score;
            _challenges[_challengeId].highScorer = _scorer;
        }
    }

     function injectFunds(uint256 _challengeId, uint256 _amount)
        external
        override
        onlyOwnerOrInjector
    {
        require(
            _challenges[_challengeId].status == Status.Open,
            "Challenge not open"
        );

        apeCoin.safeTransferFrom(
            address(msg.sender),
            address(this),
            _amount
        );

        _challenges[_challengeId].amountCollectedInAPE += _amount;
    }

    function setOperatorAndTreasuryAndInjectorAddresses(
        address _operatorAddress,
        address _treasuryAddress,
        address _injectorAddress
    ) external onlyOwner {
        require(_operatorAddress != address(0), "Cannot be zero address");
        require(_treasuryAddress != address(0), "Cannot be zero address");
        require(_injectorAddress != address(0), "Cannot be zero address");

        operatorAddress = _operatorAddress;
        treasuryAddress = _treasuryAddress;
        injectorAddress = _injectorAddress;
    }

     function viewCurrentChalengeId() external view override returns (uint256) {
        return currentChallengeId;
    }

    function viewChallenge(uint256 _challengeId)
        external
        view
        returns (Challenge memory)
    {
        return _challenges[_challengeId];
    }

    function viewScoresSubmittedForChallenge(address _user, uint256 _challengeId) external view returns (uint256[] memory){
        return _scores[_challengeId][_user];
    }

    function viewHighScoreForChallenge(uint256 _challengeId) external view returns (uint256) {
        return _challenges[_challengeId].highScore;
    }

    function closeCurrentChallengeAndDistributeRewards() internal {
       address highScorer = _challenges[currentChallengeId].highScorer;
       uint256  amountToBeTransferredToWinner = _challenges[currentChallengeId].amountCollectedInAPE * (10000 - _challenges[currentChallengeId].treasuryFee) / 10000;
       uint256 amountToBeWithdrawnInTressurary = _challenges[currentChallengeId].amountCollectedInAPE - amountToBeTransferredToWinner;

       _challenges[currentChallengeId].status = Status.Close;

       apeCoin.safeTransfer(treasuryAddress, amountToBeWithdrawnInTressurary);
       apeCoin.safeTransfer(highScorer, amountToBeTransferredToWinner);
    } 

    function _isContract(address _addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }

      function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        upkeepNeeded = block.timestamp >= _challenges[currentChallengeId].endTime && _challenges[currentChallengeId].status == Status.Open;
    }
    

    function performUpkeep(bytes calldata /* performData */) external override {
       
        if (block.timestamp >= _challenges[currentChallengeId].endTime && _challenges[currentChallengeId].status == Status.Open) {
            closeCurrentChallengeAndDistributeRewards();
        }
    }
}

