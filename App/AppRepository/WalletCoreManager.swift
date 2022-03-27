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
    
    func createWallet(from mnemonic: String? = nil,
                      passphrase: String = "",
                      completion: (String) -> Void
    ) {
        if let mnemonic = mnemonic {
            wallet = HDWallet(mnemonic: mnemonic, passphrase: "")
        } else {
            wallet = HDWallet(strength: 128, passphrase: "")
        }
        if let address = wallet?.getAddressForCoin(coin: .ethereum) {
            do {
                try KeyChainManager.shared.storePassphraseFor(address: address, password: passphrase)
                completion(address)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func retrieveAddress(coin: CoinType) -> String {
        if let wallet = wallet {
            let address = wallet.getAddressForCoin(coin: coin)
            return address
        } else {
            return ""
        }
    }
    
    func retrieveETHBalance(completion: @escaping (Double) -> Void) async {
        do {
            try await NetworkCaller.shared.getETHBalance(from: wallet?.getAddressForCoin(coin: .ethereum)) { accountBalanceInHexString in
                let availableEther = Double(hexString: accountBalanceInHexString)
                completion(availableEther)
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func signTransaction(for ether: Double,
                         address: String,
                         completion: @escaping (Bool) -> Void
    ) async {
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
                        $0.toAddress = address
                        $0.transaction = EthereumTransaction.with {
                            $0.transfer = EthereumTransaction.Transfer.with {
                                let etherInHexString = String(ether: ether)
                                $0.amount = Data(hexString: etherInHexString)!
                            }
                        }
                        $0.privateKey = wallet.getKeyForCoin(coin: .ethereum).data
                    }
                    
                    let output: EthereumSigningOutput = AnySigner.sign(input: signerInput, coin: .ethereum)
                    self.encodedSignTransaction = "0x\(output.encoded.hexString)"
                    //print(" data:   ", output.encoded.hexString)
                    
                    if let encodedSignTransaction = self.encodedSignTransaction {
                        Task {
                            try await NetworkCaller.shared.sendTransaction(with: encodedSignTransaction) { transaction in
                                DispatchQueue.main.async {
                                    self.sentTransaction = transaction
                                }
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
