//
//  GasPriceRequest.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 22/3/2565 BE.
//

//params: [
//    {
//        "from": "0xb60e8dd61c5d32be8058bb8eb970870f07233155",
//        "to": "0xd46e8dd67c5d32be8058bb8eb970870f07244567",
//        "gas": "0x76c0",
//        "gasPrice": "0x9184e72a000",
//        "value": "0x9184e72a",
//        "data": "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"
//    },
//    "latest"
//]

import Foundation

struct ETHAlchemyRequest: Encodable {
    let jsonrpc: String
    let method: String
    let params: [String]
    let id: Int
}
