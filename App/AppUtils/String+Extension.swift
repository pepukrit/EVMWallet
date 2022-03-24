//
//  String+Extension.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 24/3/2565 BE.
//

extension String {
    init(ether: Double) {
        let weiUnit: Double = 1000000000000000000
        let wei = ether * weiUnit
        let hexString = String(Int(wei), radix: 16)
        self = hexString.count % 2 == 0
        ? hexString
        : "0\(hexString)"
    }
}
