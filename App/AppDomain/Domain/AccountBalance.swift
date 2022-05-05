//
//  ERC.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 17/4/2565 BE.
//

import Foundation

struct AccountBalance {
    let address: String
    let tokenBalances: [TokenBalance]
}

struct TokenBalance {
    let contractAddress: String
    let tokenBalance: String //TODO: can delete this actually
    let tokenBalanceInDouble: Double
}
