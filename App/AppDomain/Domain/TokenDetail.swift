//
//  TokenDetail.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 2/5/2565 BE.
//

import Foundation

struct TokenDetail {
    let name: String
    let symbol: String
    let logo: String
}

struct ERC20TokenDetail {
    let tokenDetail: TokenDetail
    let tokenBalance: TokenBalance
}
