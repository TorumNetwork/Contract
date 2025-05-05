# Torum Token (XTM) & Staking Contract

This repository contains two smart contracts written in Solidity:

1. **Torum Token (XTM)** — An ERC20 token with mint and burn capabilities.
2. **StakingContract** — A basic staking system for the XTM token with configurable interest and locking period.

---

## 🪙 Torum Token (XTM)

A standard ERC20 token with the following additional features:

- **Initial supply:** 200,000,000 XTM minted to the owner on deployment.
- **Owner-only minting:** The contract owner can mint additional tokens.
- **Burning:** Any token holder can burn their own tokens.

### Contract Details

- Name: `Torum Token`
- Symbol: `XTM`
- Decimals: `18`

### Key Functions

```solidity
function mint(address to, uint256 amount) external onlyOwner;
function burn(uint256 amount) external;

🔐 StakingContract
This contract allows users to stake their XTM tokens for a fixed duration and earn interest.

Features
Fixed annual interest rate (default: 1% per year)

Only one active stake per user

Configurable staking duration per user

Owner can deposit/withdraw rewards

Rewards based on time staked

Key Parameters
annualInterestRate: e.g. 100 = 1%

SECONDS_IN_YEAR: 365 days

BASIS_POINT: 10,000 for precision

Main Functions
function stake(uint256 amount, uint256 periodInSeconds) external;
function unstake() external;
function setInterestRate(uint256 newRate) external onlyOwner;
function calculateReward(address user) external view returns (uint256);
function getStake(address user) external view returns (uint256 amount, uint256 startedAt, uint256 period, bool withdrawn);

Events
Staked(address user, uint256 amount, uint256 period)

Unstaked(address user, uint256 amount, uint256 reward)

OwnerDeposited(uint256 amount)

OwnerWithdrew(uint256 amount)

🛠 Setup & Deployment
Prerequisites
Solidity ^0.8.20

OpenZeppelin Contracts

Installation
bash
Copy
Edit
npm install @openzeppelin/contracts

Compile
Use Hardhat, Foundry, or Remix IDE.

🔒 Security Notes
The staking contract uses ReentrancyGuard for basic protection.

Only the contract owner can mint or update interest rates.

Tokens are staked with a lock period — users can’t unstake early.

📄 License
MIT License
✉️ Contact
For questions, reach out at info@torum.network
