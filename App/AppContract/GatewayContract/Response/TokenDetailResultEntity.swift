//
//  TokenDetailResultEntity.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 2/5/2565 BE.
//

import Foundation

struct TokenDetailResultEntity: Codable {
    let jsonrpc: String?
    let id: Int?
    let result: TokenDetailEntity?
    
    struct TokenDetailEntity: Codable {
        let decimals: Double?
        let logo: String?
        let name: String?
        let symbol: String?
    }
}
