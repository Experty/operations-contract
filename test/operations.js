const Operations = artifacts.require('./Operations')
const getTimestampInSeconds = () => Math.floor(Date.now() / 1000)
const sleep = time => new Promise((resolve, reject) => setTimeout(resolve, time))

contract('Operations', accounts => {
  let instance = null
  beforeEach(async () => instance = await Operations.new())
  afterEach(() => instance = null)

  it('should deposit 1000 coins in the first account', async () => {
    const balanceBeforeDeposit = await instance.getBalance.call().then(balance => balance.toNumber())
    await instance.deposit({ value: 1000 })
    const balanceAfterDeposit = await instance.getBalance.call().then(balance => balance.toNumber())
    assert.equal(balanceAfterDeposit, balanceBeforeDeposit + 1000)
  })

  it('should withdraw the requested amount', async () => {
    await instance.deposit({ value: 1000 })
    await instance.withdraw(500)
    const balanceAfterWithdrawal = await instance.getBalance.call().then(balance => balance.toNumber())
    assert.equal(balanceAfterWithdrawal, 500)
  })

  it('should not allow withdraw more than deposited value', async () => {
    await instance.deposit({ value: 500 })
    await instance
      .withdraw(1000)
      .then(tx => { throw new Error() })
      .catch(e => assert(e instanceof Error))
  })

  it('should not allow making two calls at the same time', async () => {
    await instance.startCall(accounts[0], accounts[1], 200, Date.now())
    await instance
      .startCall(accounts[0], accounts[1], 200, Date.now())
      .then(tx => { throw new Error() })
      .catch(e => assert(e instanceof Error))
  })

  it('should pay the recipient after the call', async () => {
    const depositedValue = 1000000
    const costPerS = 300
    const startTimestamp = getTimestampInSeconds()
    await instance.deposit({ value: depositedValue })
    await instance.startCall(accounts[0], accounts[1], costPerS, startTimestamp)
    await sleep(3000)
    const endTimestamp = getTimestampInSeconds()
    const callPrice = (endTimestamp - startTimestamp) * costPerS
    await instance.endCall(accounts[0], accounts[1], endTimestamp)
    const acc1bal = await instance.getBalance.call({ from: accounts[1] }).then(bal => bal.toNumber())
    const acc0bal = await instance.getBalance.call({ from: accounts[0] }).then(bal => bal.toNumber())
    assert.equal(acc1bal, callPrice)
    assert.equal(acc0bal, depositedValue - callPrice)
  })

})
