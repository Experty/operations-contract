const Operations = artifacts.require('./Operations')

contract('Operations', accounts => {
  it('should deposit 1000 coins in the first account', async () => {
    const instance = await Operations.deployed()
    const balanceBeforeDeposit = await instance.getBalance.call(accounts[0]).then(balance => balance.toNumber())
    instance
      .deposit({ value: 1000 })
      .then(() => instance.getBalance.call(accounts[0]))
      .then(balanceAfterDepositObj => balanceAfterDepositObj.toNumber())
      .then(balanceAfterDeposit => assert.equal(balanceAfterDeposit, balanceBeforeDeposit + 1000))
  })
})
