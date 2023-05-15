# Fundraising contract

### Development

**Tools**:

-   Solidity
-   Hardhat

**Commands**:

```shell
# run all tests
npm run test

# compile the smart contracts and creates the artifacs
npm run compile

# start simulated local network with prefunded wallets
npm run node

 # deploy the contracts configured in the deploy script to the local network (prev. command)
npm run deploy::local

# open a web3 cli
npm run console
```

More info: [hardhat.org](https://hardhat.org/docs)

### Participants

**Admin**

-   Creates a new project inside the smart contract
-   Changes the funding goal of a project
-   Default owner of all projects

**Investor**

-   Creates a new project
-   Donates to a project
-   Checks the total amount raised for a project

**Smart Contract**

-   Holds the logic for creating, donating to and updating a project
-   Ensures donations do not exceed the funding goal
-   Checks that the new funding goal is not less than the amount raised

### Out of scope

-   Roles & Permissions (e.g. OpenZeppelin access management)
-   Upgradability (e.g. OpenZepplin proxy)
-   Handle
