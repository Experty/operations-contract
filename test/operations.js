const Operations = artifacts.require('./Operations')

contract('Operations', accounts => {
  it('should deposit 1000 coins in the first account', async () => {
    const instance = await Operations.deployed();
    const balanceBeforeDeposit = await instance.getBalance.call(accounts[0]).then(balance => balance.toNumber())

    await instance.deposit({ value: 1000 })
    const balanceAfterDeposit = await instance.getBalance.call(accounts[0]).then(balance => balance.toNumber())
    assert.equal(balanceAfterDeposit, balanceBeforeDeposit + 1000)
  })

  it('should withdraw the requested amount', async () => {
    const instance = await Operations.deployed()
    await instance.deposit({ value: 1000 })
    await instance.withdraw(500)
    const balanceAfterWithdrawal = await instance.getBalance.call(accounts[0]).then(balance => balance.toNumber())
    assert.equal(balanceAfterWithdrawal, 500)
  })

  it('should not allow withdraw more than deposited value', async () => {
    // …
  });
})
