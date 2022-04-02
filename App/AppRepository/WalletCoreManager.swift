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
    
    @Published var boxValue: String?
    let abiManager = ContractABIManager.shared
    
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
        guard let wallet = wallet else {
            assertionFailure("Unexpectedly not found a wallet")
            return ""
        }
        let address = wallet.getAddressForCoin(coin: coin)
        return address

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
    
    func sendTransaction(to address: String, completion: @escaping (Bool) -> Void) async {
        do {
            if let wallet = wallet {
                try await prepareTransactionModel { transactionModel in
                    let signerInput = EthereumSigningInput.with {
                        $0.nonce = Data(hexString: transactionModel.nonce)!
                        $0.chainID = Data(hexString: "04")!
//                        $0.gasPrice = Data(hexString: transactionModel.gasPrice)! // decimal 3600000000
//                        $0.gasLimit = Data(hexString: "5208")! // decimal 21000
                        $0.toAddress = address
                        $0.privateKey = wallet.getKeyForCoin(coin: .ethereum).data
                        $0.transaction = EthereumTransaction.with {
                            $0.contractGeneric = EthereumTransaction.ContractGeneric.with {
                                $0.data = self.abiManager.callMethodFrom(name: "retrieve")
                            }
                        }
                    }
                    
                    self.signTransaction(from: signerInput) {
                        completion($0)
                    }
                }
            }
        } catch {
            assertionFailure(error.localizedDescription)
            return
        }
    }
    
    func sendTransaction(with ether: Double,
                         address: String,
                         completion: @escaping (Bool) -> Void
    ) async {
        do {
            if let wallet = wallet {
                try await prepareTransactionModel { transactionModel in
                    let signerInput = EthereumSigningInput.with {
                        $0.nonce = Data(hexString: transactionModel.nonce)!
                        $0.chainID = Data(hexString: "04")!
                        $0.gasPrice = Data(hexString: transactionModel.gasPrice)! // decimal 3600000000
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

                    self.signTransaction(from: signerInput) {
                        completion($0)
                    }
                }
            }
        } catch {
            assertionFailure(error.localizedDescription)
            return
        }
    }
}

private extension WalletCoreManager {
    func prepareTransactionModel(completion: @escaping (ETHTransactionModel) -> Void) async throws {
        if let _ = wallet {
            var nonce: String?
            var gasPrice: String?
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            try await NetworkCaller.shared.getTransactionCount {
                nonce = $0
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            try await  NetworkCaller.shared.fetchGasPrice {
                gasPrice = $0
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                guard let nonce = nonce, let gasPrice = gasPrice else {
                    assertionFailure("Unexpectedly found nil")
                    return
                }
                completion(ETHTransactionModel(nonce: nonce, gasPrice: gasPrice))
            }
        } else {
            throw WalletCoreTransactionError.walletNotFound
        }
    }
    
    func signTransaction(from signerInput: EthereumSigningInput, completion: @escaping (Bool) -> Void) {
        let output: EthereumSigningOutput = AnySigner.sign(input: signerInput, coin: .ethereum)
        self.encodedSignTransaction = "0x\(output.encoded.hexString)"
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

private enum WalletCoreTransactionError: Error {
    case walletNotFound
    case cannotPrepareTransaction
}
