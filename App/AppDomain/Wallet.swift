//
//  Account.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 27/2/2565 BE.
//

import SwiftUI
import web3swift
import WalletCore

struct Wallet {
    enum WalletType {
        case BIP39(mnemonic: String)
    }
    
    enum AddressType {
        case defaultAddress(String)
        case unknownAddress
    }
    
    var address: AddressType = .unknownAddress
    var data: Data?
    
    init(wallet: Wallet.WalletType, passphrase: String) {
        switch wallet {
        case .BIP39(let mnemonic):
            do {
                if let keyStore = try makeBIP32KeyStore(from: mnemonic, password: passphrase),
                   let ethAddress = keyStore.addresses?.first {
                    let keyData = try JSONEncoder().encode(keyStore.keystoreParams)
                    data = keyData // store keyData for important future use
                    address = .defaultAddress(ethAddress.address)
                }
            } catch {
                assertionFailure("There was an error during creating mnemonic to generate BIP32 seed")
                return
            }
        }
    }
    
    func getKeystoreManager() -> KeystoreManager? {
        guard let data = data, let keystore = BIP32Keystore(data) else {
            assertionFailure("Unexpectedly found nil")
            return nil
        }
        return .init([keystore])
    }
}

private extension Wallet {
    func makeBIP32KeyStore(from mnemonic: String,
                           password: String = "web3swift") throws -> BIP32Keystore? {
        try BIP32Keystore(mnemonics: mnemonic,
                          password: password,
                          mnemonicsPassword: "",
                          language: .english)
    }
}
