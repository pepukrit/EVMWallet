//
//  WalletCoreManager.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 19/3/2565 BE.
//

import Combine
import WalletCore

final class WalletCoreManager: ObservableObject {
    
    @Published var wallet: HDWallet?
    @Published var encodedSignTransaction: String?
    @Published var sentTransaction: String?
    
    func createWallet(from mnemonic: String? = nil, passphrase: String = "") {
        if let mnemonic = mnemonic {
            wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        } else {
            wallet = HDWallet(strength: 128, passphrase: passphrase)
        }
        print(wallet?.getAddressForCoin(coin: .ethereum) ?? "")
    }
    
    func retrieveAddress(coin: CoinType) -> String {
        if let wallet = wallet {
            let address = wallet.getAddressForCoin(coin: coin)
            return address
        } else {
            return ""
        }
    }
    
    func signTransaction(completion: @escaping (Bool) -> Void) async {
        do {
            if let wallet = wallet {
                var nonce: String?
                var gasPrice: String?
                
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                try await NetworkCaller.shared.getTransactionCount {
                    nonce = $0
                    dispatchGroup.leave()
                }
                
                dispatchGroup.enter()
                try await NetworkCaller.shared.fetchGasPrice {
                    gasPrice = $0
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main) {
                    guard let nonce = nonce, let gasPrice = gasPrice else {
                        assertionFailure("Unexpectedly found nil")
                        return
                    }
                    let signerInput = EthereumSigningInput.with {
                        $0.nonce = Data(hexString: nonce)!
                        $0.chainID = Data(hexString: "04")!
                        $0.gasPrice = Data(hexString: gasPrice)! // decimal 3600000000
                        $0.gasLimit = Data(hexString: "5208")! // decimal 21000
                        $0.toAddress = "0x990a2CF2072d24c3663f4C9CAf5CE7829b1A2d0a"
                        $0.transaction = EthereumTransaction.with {
                            $0.transfer = EthereumTransaction.Transfer.with {
                                $0.amount = Data(hexString: "b1a2bc2ec50000")! // 0.5 eth
                            }
                        }
                        $0.privateKey = wallet.getKeyForCoin(coin: .ethereum).data
                    }
                    
                    let output: EthereumSigningOutput = AnySigner.sign(input: signerInput, coin: .ethereum)
                    self.encodedSignTransaction = "0x\(output.encoded.hexString)"
                    //print(" data:   ", output.encoded.hexString)
                    
                    if let encodedSignTransaction = self.encodedSignTransaction {
                        Task {
                            try await NetworkCaller.shared.sendTransaction(with: encodedSignTransaction) {
                                self.sentTransaction = $0
                                completion(true)
                            }
                        }
                    }
                }
            }
        } catch {
            return
        }
    }
}
