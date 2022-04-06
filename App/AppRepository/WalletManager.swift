//
//  WalletManager.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 4/4/2565 BE.
//

import Combine

final class WalletManager: ObservableObject {
    @Published var walletManagerType: WalletManagerType?
}

enum WalletManagerType {
    case web3swift(Web3SwiftWalletManager)
    case walletCore(WalletCoreManager)
}
