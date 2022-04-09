//
//  GenericSCRequest.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 2/4/2565 BE.
//

import Foundation

struct GenericSCRequest: Encodable {
    let from: String
    let to: String
    let data: String
}
