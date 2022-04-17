//
//  WalletManager.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 4/4/2565 BE.
//

import Combine

final class WalletManager: ObservableObject {
    @Published var walletManagerType: WalletManagerType?
    
    var web3SwiftWallet: Web3SwiftWalletManager? {
        guard let walletManagerType = walletManagerType else {
            assertionFailure("Unexpectedly found nil")
            return nil
        }
        switch walletManagerType {
        case .web3swift(let wallet):
            return wallet
        case .walletCore:
            return nil
        }
    }
    
    var walletCoreSwiftWallet: WalletCoreManager? {
        guard let walletManagerType = walletManagerType else {
            assertionFailure("Unexpectedly found nil")
            return nil
        }
        switch walletManagerType {
        case .web3swift:
            return nil
        case .walletCore(let wallet):
            return wallet
        }
    }
}

extension WalletManager {
    var address: String {
        guard let walletManagerType = walletManagerType else {
            assertionFailure("Unexpectedly found nil")
            return "Unidentified"
        }
        switch walletManagerType {
        case .web3swift(let wallet):
            return wallet.wallet?.ethAddress ?? "Unidentified"
        case .walletCore(let wallet):
            return wallet.retrieveAddress(coin: .ethereum)
        }
    }
    
    var accounts: [ERC20TokenModel] {
        guard let walletManagerType = walletManagerType else {
            assertionFailure("Unexpectedly found nil")
            return []
        }
        switch walletManagerType {
        case .walletCore(let wallet):
            return wallet.accounts
        case .web3swift(let wallet):
            return wallet.accounts
        }
    }
}

enum WalletManagerType {
    case web3swift(Web3SwiftWalletManager)
    case walletCore(WalletCoreManager)
}

extension WalletManagerType {
    var isWeb3SwiftWallet: Bool {
        switch self {
        case .web3swift: return true
        case .walletCore: return false
        }
    }
    
    var isWalletCoreWallet: Bool {
        switch self {
        case .web3swift: return false
        case .walletCore: return true
        }
    }
}
