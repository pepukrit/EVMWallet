//
//  ContractABIManager.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 1/4/2565 BE.
//

import Foundation
import WalletCore

final class ContractABIManager {
    
    static let shared = ContractABIManager()
    
    func callMethodFrom(name: String) -> Data {
        let function = EthereumAbiFunction(name: "retrieve")
        return EthereumAbi.encode(fn: function)
    }
}
