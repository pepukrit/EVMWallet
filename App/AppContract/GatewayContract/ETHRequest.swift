//
//  GasPriceRequest.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 22/3/2565 BE.
//

struct ETHRequest: Encodable {
    let jsonrpc: String
    let method: String
    let params: [String]
    let id: Int
}
