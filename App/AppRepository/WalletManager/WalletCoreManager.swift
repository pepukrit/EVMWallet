//
//  WalletCoreManager.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 19/3/2565 BE.
//

import Combine
import WalletCore

final class WalletCoreManager: ObservableObject {
    enum AccountState {
        case viewIsReady, loading, empty, notEmpty
    }
    
    @Published var wallet: HDWallet?
    @Published var state: AccountState = .viewIsReady
    
    //TODO: Clean up these local variables
    @Published var accounts: [ERC20TokenModel] = []
    @Published var totalPrice: Double = 0
    @Published var encodedSignTransaction: String?
    @Published var sentTransaction: String?
    
    let abiManager = ContractABIManager.shared
    let accountBalanceNetworkRepository: AccountBalanceNetworkRepository
    
    init() {
        accountBalanceNetworkRepository = AccountBalanceNetworkRepositoryImplementation()
    }
    
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
            return "UNDEFINED"
        }
        let address = wallet.getAddressForCoin(coin: coin)
        return address

    }
    
    func retrieveETHBalance() async -> Double {
        do {
            let result = try await NetworkCaller.shared.getETHBalance(from: wallet?.getAddressForCoin(coin: .ethereum))
            let availableEther = Double(hexStringWithEther: result.result)
            return availableEther
        } catch {
            assertionFailure(error.localizedDescription)
            return 0
        }
    }
    
    func sendTransaction(to address: String, completion: @escaping (Int) -> Void) async {
        if let wallet = wallet {
            let fromAddress = wallet.getAddressForCoin(coin: .ethereum) // Optional field
            let toAddress = address
            let data = self.abiManager.callMethodFrom(name: "retrieve")
            
            let scRequest = GenericSCRequest(from: fromAddress,
                                             to: toAddress,
                                             data: "0x\(data.hexString)")
            
            Task {
                try await NetworkCaller.shared.call(with: scRequest) {
                    let boxValueInInt = Int(hexString: $0)
                    completion(boxValueInInt)
                }
            }
        }
    }
    
    func sendTransaction(with ether: Double,
                         address: String,
                         completion: @escaping (Bool) -> Void
    ) async {
        do {
            if let wallet = wallet {
                let preparedETHModel = try await prepareTransactionModel()
                let signerInput = EthereumSigningInput.with {
                    $0.nonce = Data(hexString: preparedETHModel.nonce)!
                    $0.chainID = Data(hexString: "04")! // https://besu.hyperledger.org/en/stable/Concepts/NetworkID-And-ChainID/
                    $0.gasPrice = Data(hexString: preparedETHModel.gasPrice)!
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

                let signedTransaction = await signTransaction(from: signerInput)
                signedTransaction.map { transaction in
                    DispatchQueue.main.async {
                        self.sentTransaction = transaction
                    }
                }
                completion(true)
            }
        } catch {
            assertionFailure(error.localizedDescription)
            completion(false)
        }
    }
    
    func sendERC20Transaction(with ether: Double,
                              coin: ERC20TokenCoin,
                              address: String,
                              completion: @escaping (Bool) -> Void
    ) async {
        do {
            if let wallet = wallet {
                let preparedETHModel = try await prepareTransactionModel()
                let signerInput = EthereumSigningInput.with {
                    $0.nonce = Data(hexString: preparedETHModel.nonce)!
                    $0.chainID = Data(hexString: "04")! // https://besu.hyperledger.org/en/stable/Concepts/NetworkID-And-ChainID/
                    $0.gasPrice = Data(hexString: preparedETHModel.gasPrice)!
                    $0.gasLimit = Data(hexString: "033450")! // decimal 210000
                    $0.toAddress = coin.address
                    $0.transaction = EthereumTransaction.with {
                        $0.erc20Transfer = EthereumTransaction.ERC20Transfer.with {
                            let etherInHexString = String(ether: ether)
                            $0.to = address
                            $0.amount = Data(hexString: etherInHexString)!
                        }
                    }
                    $0.privateKey = wallet.getKeyForCoin(coin: .ethereum).data
                }

                let signedTransaction = await signTransaction(from: signerInput)
                signedTransaction.map { transaction in
                    DispatchQueue.main.async {
                        self.sentTransaction = transaction
                    }
                }
                completion(true)
            }
        } catch {
            assertionFailure(error.localizedDescription)
            completion(false)
        }
    }
}

extension WalletCoreManager: WalletManagerProtocol {
    func getERC20TokenBalances(address: String, contractAddresses: [String]) async {
        state = .loading
        guard let accountBalance = await accountBalanceNetworkRepository.getTokenBalances(
            from: address,
            contractAddresses: contractAddresses
        ), let ethBalance = await accountBalanceNetworkRepository.getETHBalance(from: address) else {
            state = .viewIsReady
            return assertionFailure("Cannot retrieve account balance from the address: \(address)")
        }
        let tokenBalances =  accountBalance.tokenBalances
        let erc20TokensDetail: [ERC20TokenDetail] = await tokenBalances.prefix(5).asyncCompactMap {
            guard let tokenDetail = await accountBalanceNetworkRepository.getTokenDetail(from: $0.contractAddress) else {
                return nil
            }
            return .init(tokenDetail: tokenDetail, tokenBalance: $0)
        }
        let ethTokenModel: ERC20TokenModel = .init(tokenName: ERC20TokenCoin.ethereum.tokenName,
                                                   tokenAmount: "\(String(format: "%.3f", ethBalance.balance))",
                                                   tokenAbbr: ERC20TokenCoin.ethereum.tokenSymbol,
                                                   totalPrice: "$\(String(format: "%.3f", ethBalance.balanceInUSD))",
                                                   unrealizedDiff: "",
                                                   coinType: .ethereum)
        
        let erc20TokenModels: [ERC20TokenModel] = erc20TokensDetail.compactMap {
            .init(tokenName: $0.tokenDetail.name,
                  tokenAmount: "\(String(format: "%.3f", $0.tokenBalance.tokenBalanceInDouble))",
                  tokenAbbr: $0.tokenDetail.logo,
                  totalPrice: "$\(String(format: "%.3f", $0.tokenDetail.rateInUSD * $0.tokenBalance.tokenBalanceInDouble))",
                  unrealizedDiff: "",
                  coinType: .chainlink)
        }
        
        var price: Double = 0
        _ = erc20TokensDetail.compactMap { price += $0.tokenBalance.tokenBalanceInDouble }
        price += ethBalance.balanceInUSD
        let totalPrice = price
        
        let allTokenModels: [ERC20TokenModel] = [ethTokenModel] + erc20TokenModels
        DispatchQueue.main.async {
            self.accounts = allTokenModels
            self.totalPrice = totalPrice
            self.state = allTokenModels.isEmpty ? .empty : .notEmpty
        }
    }
}

private extension WalletCoreManager {
    func prepareTransactionModel() async throws -> ETHTransactionModel {
        guard let _ = wallet else { throw WalletCoreTransactionError.walletNotFound }
        let nonce = try await NetworkCaller.shared.getTransactionCount().result
        let gasPrice = try await NetworkCaller.shared.fetchGasPrice().result
        return .init(nonce: nonce, gasPrice: gasPrice)
    }
    
    func signTransaction(from signerInput: EthereumSigningInput) async -> String? {
        let output: EthereumSigningOutput = AnySigner.sign(input: signerInput, coin: .ethereum)
        self.encodedSignTransaction = "0x\(output.encoded.hexString)"
        do {
            let result = try await NetworkCaller.shared.sendTransaction(with: encodedSignTransaction)
            return result.result
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
}

private enum WalletCoreTransactionError: Error {
    case walletNotFound
    case cannotPrepareTransaction
}
