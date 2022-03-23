//
//  ERC20TokenView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 2/3/2565 BE.
//

import Foundation
import WalletCore

struct ERC20TokenViewModel {
    let image: String
    let tokenName: String
    let tokenAmount: String
    let tokenSymbol: String
    let totalPrice: String
    let unrealizedDiff: String
}

extension ERC20TokenViewModel {
    init(from erc20Token: ERC20TokenModel) {
        image = erc20Token.coinType.image
        tokenName = erc20Token.tokenName
        tokenAmount = erc20Token.tokenAmount
        tokenSymbol = erc20Token.tokenAbbr
        totalPrice = erc20Token.totalPrice
        unrealizedDiff = erc20Token.unrealizedDiff
    }
}

private extension ERC20TokenCoin {
    var image: String {
        switch self {
        case .binance: return "bnb"
        case .cardano: return "ada"
        case .ethereum: return "eth"
        case .solana: return "sol"
        case .avalancheCChain: return "avax"
        case .chainlink: return "link"
        default:
            return ""
        }
    }
}
