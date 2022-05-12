//
//  AccountCoins.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 1/3/2565 BE.
//

import WalletCore

struct ERC20TokenModel: Identifiable {
    var id: String { tokenAbbr }
    let tokenName: String // Cardano
    let tokenAmount: String // 1000
    let tokenAbbr: String // ADA
    let totalPrice: String // $1000
    let unrealizedDiff: String // +10%
    let coinType: ERC20TokenCoin
}
