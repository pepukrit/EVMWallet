//
//  TokenBalanceResult.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 9/4/2565 BE.
//

import Foundation

struct TokenBalanceResultEntity: Codable {
    let jsonrpc: String?
    let id: Int?
    let result: TokenBalanceDetailEntity?
    
    struct TokenBalanceDetailEntity: Codable {
        let address: String?
        let tokenBalances: [TokenBalance]
        
        struct TokenBalance: Codable {
            let contractAddress: String?
            let tokenBalance: String?
            let error: TokenBalanceError?
            
            struct TokenBalanceError: Codable {
                let code: Int?
                let message: String?
            }
        }
    }
}
