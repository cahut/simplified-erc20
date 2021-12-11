from brownie import ERC20, network, config
from scripts.helpful_scripts import get_account


def deploy_token(initial_amount):
    account = get_account()
    token = ERC20.deploy("Token", "TKN", initial_amount, {"from": account})

    print(f"Contract deployed to {token.address}")

    return token


def main():
    deploy_token()
