import { loadFixture } from '@nomicfoundation/hardhat-network-helpers'
import { expect } from 'chai'
import { ethers } from 'hardhat'
import hre from 'hardhat'

describe('FundraiserContract', function () {
    async function deployFixture() {
        const [owner, otherAccount] = await ethers.getSigners()
        const FundraiserContract = await hre.ethers.getContractFactory(
            'FundraiserContract'
        )

        const contract = await FundraiserContract.deploy()

        return { contract, owner, otherAccount }
    }
    describe('Deployment', function () {
        it('Should set the right owner', async function () {
            // Given
            const { contract, owner } = await loadFixture(deployFixture)

            // Then
            expect(await contract.owner()).to.equal(owner.address)
        })
    })

    describe('Projects', function () {
        describe('Validations', function () {
            it('Should revert if new funding goal is lower than curently invested', async function () {
                // Given
                const { contract } = await loadFixture(deployFixture)

                await contract.createProject(123, ethers.utils.parseEther('5'))

                await contract.contribute(123, {
                    value: ethers.utils.parseEther('2'),
                })

                // Then
                await expect(
                    contract.setFundingGoal(123, ethers.utils.parseEther('1'))
                ).to.be.revertedWith(
                    'Funding goal must be higher or equal than the current amount'
                )
            })

            it('Should revert if contributing amount will exceed the funding goal', async function () {
                // Given
                const { contract } = await loadFixture(deployFixture)

                await contract.createProject(123, ethers.utils.parseEther('5'))

                // Then
                await expect(
                    contract.contribute(123, {
                        value: ethers.utils.parseEther('6'),
                    })
                ).to.be.revertedWith(
                    'Cannot contribute more than the funding goal'
                )
            })

            it('Should correctly return the current amount of a project', async function () {
                // Given
                const { contract } = await loadFixture(deployFixture)

                await contract.createProject(123, ethers.utils.parseEther('5'))
                await contract.contribute(123, {
                    value: ethers.utils.parseEther('0.14'),
                })

                // Then
                expect(
                    await contract.getProjectTotalAmountRaised(123)
                ).to.equal(ethers.utils.parseEther('0.14'))
            })

            it('Should revert if the project id already exists on creation', async function () {
                // Given
                const { contract } = await loadFixture(deployFixture)

                await contract.createProject(123, 500)

                // Then
                await expect(
                    contract.createProject(123, 100)
                ).to.be.revertedWith('Project with that ID already exists')
            })

            it('Should revert if the project id does not exist', async function () {
                // Given
                const { contract } = await loadFixture(deployFixture)

                // Then
                await expect(
                    contract.getProjectTotalAmountRaised(123)
                ).to.be.revertedWith('Project with that ID does not exist')
            })
        })
        describe('Events', function () {
            it('Should emit an event on creation of a project', async function () {
                // Given
                const { contract, owner } = await loadFixture(deployFixture)

                // Then
                await expect(
                    contract.createProject(123, ethers.utils.parseEther('5'))
                )
                    .to.emit(contract, 'ProjectCreated')
                    .withArgs(
                        123,
                        ethers.utils.parseEther('5'),
                        0,
                        owner.address
                    )
            })
            it('Should emit an event on contribution to a project', async function () {
                // Given
                const { contract, owner, otherAccount } = await loadFixture(
                    deployFixture
                )

                await contract.createProject(123, ethers.utils.parseEther('5'))

                // Then
                await expect(
                    contract.contribute(123, {
                        value: ethers.utils.parseEther('0.14'),
                    })
                )
                    .to.emit(contract, 'ContributionMade')
                    .withArgs(
                        123,
                        ethers.utils.parseEther('5'),
                        ethers.utils.parseEther('0.14'),
                        owner.address
                    )
            })

            it('Should emit an event on updating the funding goal of a project', async function () {
                // Given
                const { contract, owner } = await loadFixture(deployFixture)

                await contract.createProject(123, ethers.utils.parseEther('5'))

                // Then
                await expect(
                    contract.setFundingGoal(123, ethers.utils.parseEther('10'))
                )
                    .to.emit(contract, 'FundingGoalUpdated')
                    .withArgs(
                        123,
                        ethers.utils.parseEther('5'),
                        ethers.utils.parseEther('10'),
                        owner.address
                    )
            })
        })

        describe('Transfers', function () {
            it('Should update the projects currentAmount', async function () {
                // Given
                const { contract } = await loadFixture(deployFixture)

                await contract.createProject(123, ethers.utils.parseEther('5'))

                // When
                await contract.contribute(123, {
                    value: ethers.utils.parseEther('0.14'),
                })

                // Then
                expect(
                    await contract.getProjectTotalAmountRaised(123)
                ).to.equal(ethers.utils.parseEther('0.14'))
            })

            it('Should add multiple contributions to the projects funds', async function () {
                // Given
                const { contract, owner, otherAccount } = await loadFixture(
                    deployFixture
                )

                await contract.createProject(123, ethers.utils.parseEther('5'))

                // When
                await contract.contribute(123, {
                    value: ethers.utils.parseEther('0.5'),
                })

                await contract.connect(otherAccount).contribute(123, {
                    value: ethers.utils.parseEther('0.6'),
                })

                // Then
                expect(
                    await contract.getProjectTotalAmountRaised(123)
                ).to.equal(ethers.utils.parseEther('1.1'))
            })
        })
    })
})
