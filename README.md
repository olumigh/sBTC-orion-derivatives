
# sBTC-orion-derivatives - Decentralized Derivatives Trading Smart Contract

A Clarity smart contract for implementing decentralized derivatives trading on the Stacks blockchain. This contract allows users to deposit collateral, open leveraged long/short positions, close positions to realize PnL, and manage balances in a transparent, decentralized manner.

---

## 🚀 Features

✅ Open long and short leveraged positions
✅ Deposit and withdraw collateral (STX)
✅ Liquidation price calculation based on position and leverage
✅ Simplified PnL (Profit and Loss) calculation
✅ Position management (tracking size, entry price, leverage, etc.)
✅ Admin-controlled price oracle (testnet/dev mode)
✅ Upgradeable contract ownership
✅ Strict collateral requirements and error handling

---

## 📂 Contract Components

### ### Constants and Error Codes

| Constant                      | Description                         |
| ----------------------------- | ----------------------------------- |
| `ERR-UNAUTHORIZED`            | Action restricted to contract owner |
| `ERR-INVALID-AMOUNT`          | Invalid amount provided             |
| `ERR-INSUFFICIENT-BALANCE`    | User balance insufficient           |
| `ERR-INVALID-POSITION`        | Invalid position details provided   |
| `ERR-INSUFFICIENT-COLLATERAL` | Collateral below required threshold |
| `MIN-COLLATERAL-RATIO`        | Minimum 150% collateral enforcement |
| `TYPE-LONG`                   | Long position identifier            |
| `TYPE-SHORT`                  | Short position identifier           |

---

## 🗄 Data Maps & State Variables

* **`balances`**: Tracks STX balance per user
* **`positions`**: Tracks all open positions
* **`position-counter`**: Global counter for assigning unique position IDs
* **`contract-owner`**: Admin address with elevated permissions
* **`current-price`**: Simplified price oracle (manual for test/dev purposes)

---

## 📚 Function Overview

### 🔎 Read-Only Functions

| Function                      | Description                                 |
| ----------------------------- | ------------------------------------------- |
| `get-balance (user)`          | Get STX balance for a user                  |
| `get-position (position-id)`  | Retrieve position details by ID             |
| `get-current-price`           | Get the current price from the oracle       |
| `calculate-liquidation-price` | Compute liquidation price based on position |

---

### 💡 Public Functions

| Function                                        | Description                                       |
| ----------------------------------------------- | ------------------------------------------------- |
| `deposit-collateral (amount)`                   | Deposit STX collateral                            |
| `withdraw-collateral (amount)`                  | Withdraw available STX collateral                 |
| `open-position (position-type, size, leverage)` | Open a leveraged long/short position              |
| `close-position (position-id)`                  | Close a position, realize PnL, release collateral |
| `update-price (new-price)`                      | Admin-only: Update current price (mock oracle)    |
| `set-contract-owner (new-owner)`                | Admin-only: Transfer contract ownership           |

---

### 🔒 Private Functions

| Function                   | Description                                                 |
| -------------------------- | ----------------------------------------------------------- |
| `calculate-pnl (position)` | Compute unrealized profit or loss based on position details |

---

## ⚖️ Liquidation Mechanism

Positions are liquidated automatically if the market price reaches the calculated liquidation price, which depends on:

* **Leverage used**
* **Entry price**
* **Position type (Long/Short)**

Liquidation price formula (simplified):

```clarity
Long:  entry-price * (1 - 1/leverage)
Short: entry-price * (1 + 1/leverage)
```

---

## 🔧 Admin Controls

The contract owner can:

* **Update current price** (acting as oracle for test purposes)
* **Transfer ownership** to another principal

---

## 📢 Example Usage Flow

1. User deposits STX as collateral
2. User opens a leveraged long/short position
3. Position tracks entry price, size, leverage, liquidation price
4. User closes the position to realize PnL
5. Collateral and profit (if applicable) returned to the user

---

## ⚠️ Notes & Assumptions

* **Price Oracle Simplified**: The price feed is manual for testing; replace with a decentralized oracle in production
* **PnL Calculation Simplified**: Does not account for complex market factors like funding rates, slippage, etc.
* **No Automatic Liquidation Logic**: Only liquidation price calculation is provided; enforcement mechanism to be implemented externally
* **Security Considerations**: Review thoroughly before deploying to mainnet

---

## 🛠️ Deployment Prerequisites

* Stacks Blockchain setup (Testnet or Devnet recommended)
* Clarity smart contract environment
* Developer familiarity with DeFi principles

---

## 📄 License

Open-source. MIT License or similar, customizable based on project preferences.

---
