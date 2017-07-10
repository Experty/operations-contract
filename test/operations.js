const Operations = artifacts.require('./Operations')

contract('Operations', accounts => {
  let instance = null
  beforeEach(async () => instance = await Operations.new())
  afterEach(() => instance = null)

  it('should deposit 1000 coins in the first account', async () => {
    const balanceBeforeDeposit = await instance.getBalance.call(accounts[0]).then(balance => balance.toNumber())
    await instance.deposit({ value: 1000 })
    const balanceAfterDeposit = await instance.getBalance.call(accounts[0]).then(balance => balance.toNumber())
    assert.equal(balanceAfterDeposit, balanceBeforeDeposit + 1000)
  })

  it('should withdraw the requested amount', async () => {
    await instance.deposit({ value: 1000 })
    await instance.withdraw(500)
    const balanceAfterWithdrawal = await instance.getBalance.call(accounts[0]).then(balance => balance.toNumber())
    assert.equal(balanceAfterWithdrawal, 500)
  })

  it('should not allow withdraw more than deposited value', async () => {
    await instance.deposit({ value: 500 })
    await instance
      .withdraw(1000)
      .then(tx => assert(!tx))
      .catch(e => assert(e instanceof Error))
  })

  it('should not allow making two calls at the same time', async () => {
    await instance.startCall(accounts[0], accounts[1], 200, Date.now())
    await instance
      .startCall(accounts[0], accounts[1], 200, Date.now())
      .then(tx => assert(!tx))
      .catch(e => assert(e instanceof Error))
  })

})
