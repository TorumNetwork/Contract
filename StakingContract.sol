// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract StakingContract is ReentrancyGuard {
    using SafeERC20 for IERC20;

    string public name = "Staking Contract Torum Token (XTM)";
    IERC20 public stakingToken;
    address public owner;

    uint256 public annualInterestRate = 100; // 1% (100 / 10000)
    uint256 public constant BASIS_POINT = 10000;
    uint256 public constant SECONDS_IN_YEAR = 365 days;

    struct Stake {
        uint256 amount;
        uint256 stakingTimestamp;
        uint256 stakingPeriod;
        bool withdrawn;
    }

    mapping(address => Stake) public stakes;
    mapping(address => bool) public hasStaked;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    event Staked(address indexed user, uint256 amount, uint256 period);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    event OwnerDeposited(uint256 amount);
    event OwnerWithdrew(uint256 amount);

    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
        owner = msg.sender;
    }

    function setInterestRate(uint256 _rate) external onlyOwner {
        annualInterestRate = _rate;
    }

    function depositByOwner(uint256 amount) external onlyOwner {
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit OwnerDeposited(amount);
    }

    function withdrawByOwner(uint256 amount) external onlyOwner {
        stakingToken.safeTransfer(msg.sender, amount);
        emit OwnerWithdrew(amount);
    }

    function stake(uint256 amount, uint256 periodInSeconds) external nonReentrant {
        require(amount > 0, "Amount must be > 0");
        require(periodInSeconds > 0, "Period must be > 0");
        require(!hasStaked[msg.sender], "Already staked");

        stakingToken.safeTransferFrom(msg.sender, address(this), amount);

        stakes[msg.sender] = Stake({
            amount: amount,
            stakingTimestamp: block.timestamp,
            stakingPeriod: periodInSeconds,
            withdrawn: false
        });

        hasStaked[msg.sender] = true;

        emit Staked(msg.sender, amount, periodInSeconds);
    }

    function unstake() external nonReentrant {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No active stake");
        require(!userStake.withdrawn, "Already withdrawn");
        require(block.timestamp >= userStake.stakingTimestamp + userStake.stakingPeriod, "Stake is still locked");

        uint256 timeStaked = block.timestamp - userStake.stakingTimestamp;
        uint256 reward = (userStake.amount * annualInterestRate * timeStaked) / (BASIS_POINT * SECONDS_IN_YEAR);
        uint256 totalAmount = userStake.amount + reward;

        userStake.withdrawn = true;
        stakingToken.safeTransfer(msg.sender, totalAmount);

        emit Unstaked(msg.sender, userStake.amount, reward);
    }

    function calculateReward(address _user) external view returns (uint256) {
        Stake memory userStake = stakes[_user];
        if (userStake.amount == 0 || userStake.withdrawn) return 0;

        uint256 timeStaked = block.timestamp - userStake.stakingTimestamp;
        uint256 reward = (userStake.amount * annualInterestRate * timeStaked) / (BASIS_POINT * SECONDS_IN_YEAR);
        return reward;
    }

    function getStake(address _user) external view returns (uint256 amount, uint256 startedAt, uint256 period, bool withdrawn) {
        Stake memory s = stakes[_user];
        return (s.amount, s.stakingTimestamp, s.stakingPeriod, s.withdrawn);
    }
}
