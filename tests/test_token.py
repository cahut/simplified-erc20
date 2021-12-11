from brownie import ERC20, accounts, config, reverts
from scripts.deploy_token import deploy_token
from scripts.helpful_scripts import get_account


def test_balances():
    account = get_account()

    initial_amount = 100000000000000000000
    token = ERC20.deploy("Token", "TKN", initial_amount, {"from": account})

    # testing initial balance
    assert token.balanceOf(account.address, {"from": account}) == initial_amount


def test_transfer():
    account = get_account()
    recipient = accounts[1]
    hacker = accounts[2]

    initial_amount = 100000000000000000000
    token = ERC20.deploy("Token", "TKN", initial_amount, {"from": account})

    # testing balances after transfers
    token.transfer(recipient, initial_amount / 2, {"from": account})
    assert token.balanceOf(recipient, {"from": account}) == initial_amount / 2
    assert token.balanceOf(account, {"from": account}) == initial_amount / 2

    # testing that transfers with insufficient funds reverts
    with reverts():
        token.transfer(recipient, initial_amount, {"from": hacker})
        token.transfer(recipient, initial_amount, {"from": account})


def test_allowance():
    account = get_account()
    spender = accounts[1]
    recipient = accounts[2]
    hacker = accounts[3]

    initial_amount = 100000000000000000000
    token = ERC20.deploy("Token", "TKN", initial_amount, {"from": account})

    # setting and spending full allowance
    token.increaseAllowance(spender, initial_amount / 2, {"from": account})
    token.transferFrom(account, recipient, initial_amount / 2, {"from": spender})

    # allowance is already spent for this user, so sending again should revert
    with reverts():
        token.transferFrom(account, recipient, initial_amount / 2, {"from": spender})
