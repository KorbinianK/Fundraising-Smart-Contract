import { ethers } from 'hardhat'

async function main() {
    const FundraiserContract = await ethers.getContractFactory(
        'FundraiserContract'
    )
    const contract = await FundraiserContract.deploy()

    await contract.deployed()

    console.log(`Contract ${contract.address}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
