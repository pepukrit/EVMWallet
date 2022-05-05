//
//  WalletManagerProtocol.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 6/4/2565 BE.
//

protocol WalletManagerProtocol {
    func getERC20TokenBalances(address: String, contractAddresses: [String]) async
}
