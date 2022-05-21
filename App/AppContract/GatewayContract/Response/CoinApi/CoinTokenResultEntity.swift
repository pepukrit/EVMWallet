//
//  CoinTokenResultEntity.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 21/5/2565 BE.
//

struct CoinTokenResultEntity: Codable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
