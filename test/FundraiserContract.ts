import { time, loadFixture } from '@nomicfoundation/hardhat-network-helpers'
import { anyValue } from '@nomicfoundation/hardhat-chai-matchers/withArgs'
import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('FundraiserContract', function () {
    describe('Deployment', function () {
        it('Should set the right owner', async function () {})
    })

    describe('Projects', function () {
        describe('Validations', function () {
            it('Should revert if new funding goal is lower than curently invested', async function () {})
            it('Should revert if contributing amount will exceed the funding goal', async function () {})
            it('Should correctly return the current amount of a project', async function () {})
        })

        describe('Events', function () {
            it('Should emit an event on creation of a project', async function () {})
            it('Should emit an event on contribution to a project', async function () {})
            it('Should emit an event on updating the funding goal of a project', async function () {})
        })

        describe('Transfers', function () {
            it('Should update the projects currentAmount', async function () {})
        })
    })
})
