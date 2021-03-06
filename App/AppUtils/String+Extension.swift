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

extension Double {
    init(hexStringWithEther: String) {
        let weiUnit: Double = 1000000000000000000
        let hexFloat = Float(hexStringWithEther) ?? 0
        self = Double(hexFloat) / weiUnit
    }
    
    init(hexString: String) {
        let hexFloat = Float(hexString) ?? 0
        self = Double(hexFloat)
    }
}

extension Int {
    init(hexString: String) {
        let hexFloat = Float(hexString) ?? 0
        self = Int(hexFloat)
    }
}
