//
//  WalletManager.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import BigInt
import SwiftUI
import web3swift
import WalletCore

final class WalletManager: ObservableObject {
    @Published var wallet: Wallet?
    @Published var accounts: [ERC20TokenModel] = []
    @Published var state: WalletState = .idle
    
    enum WalletState {
        case creatingWallet
        case fetchingBalance
        case idle
    }
    
    func createWallet(with type: Wallet.WalletType, passphrase: String, completion: () -> Void) {
        DispatchQueue.main.async {
            self.state = .creatingWallet
        }
        
        let newWallet: Wallet = .init(wallet: type, passphrase: passphrase)
        
        DispatchQueue.main.async {
            self.wallet = newWallet
        }
        completion()
    }
    
    func retrieveBalance(with network: ETHNetwork) {
        DispatchQueue.main.async {
            self.state = .fetchingBalance
        }
        
        let eth = getEthereumBalance(network: network)
        
        let bnb = getERC20TokenBalance(from: .binance, network: network)
        let ada = getERC20TokenBalance(from: .cardano, network: network)
        let avax = getERC20TokenBalance(from: .avalancheCChain, network: network)
        let link = getERC20TokenBalance(from: .chainlink, network: network)
        
        DispatchQueue.main.async {
            self.accounts = [eth, bnb, ada, avax, link].compactMap { $0 }
            self.state = .idle
        }
    }
    
    func sendETH(from network: ETHNetwork, to address: String, amount: String, passphrase: String, completion: () -> Void) throws {
        let web3 = getWeb3Object(from: network)
        
        guard let ethAddress = wallet?.ethAddress else {
            throw TransactionError.unableToSendETH
        }
        
        let value: String = amount // In Ether
        guard let walletAddress = EthereumAddress(ethAddress),
              let toAddress = EthereumAddress(address),
              let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        else {
            throw TransactionError.ethTokenParameterNotValidToSend
        }
        let contract = web3.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        let tx = contract.write(
            "fallback",
            parameters: [AnyObject](),
            extraData: Data(),
            transactionOptions: options)
        
        do {
            let result = try tx?.send(password: passphrase)
            print("Result: ", result?.transaction.description)
    //        let blockNumber = try web3.eth.getBlockNumber()
    //        print("#Block: ", blockNumber)
            completion()
        } catch {
            throw TransactionError.wrongPassphrase
        }
    }
    
    func sendERC20Token(coin: ERC20TokenCoin, from network: ETHNetwork, to address: String, amount: String, passphrase: String, completion: () -> Void) throws {
        let value: String = amount // In token
        let web3 = getWeb3Object(from: network)
        guard let walletAddress = EthereumAddress(wallet?.ethAddress ?? ""),
              let toAddress = EthereumAddress(address),
              let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        else {
            throw TransactionError.erc20TokenParametersNotValidToSend
        }
        let erc20ContractAddress = EthereumAddress(coin.address)
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)
        
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        let method = "transfer"
        let tx = contract?.write(method, parameters: [toAddress, amount] as [AnyObject], extraData: Data(), transactionOptions: options)
        
        do {
            let result = try tx?.send(password: passphrase)
            print("Result: ", result?.transaction.description)
            completion()
        } catch {
            throw TransactionError.wrongPassphrase
        }
    }
    
    func readSmartContract() throws -> String {
        let web3 = getWeb3Object(from: .rinkeby)
        guard let walletAddress = EthereumAddress(wallet?.ethAddress ?? "") else {
            return ""
        }
        let contractMethod = "retrieve"
        let contractABI = ContractABI.box
        let contractAddress = EthereumAddress("0x402F907757C3B745d4a809223a7251Fe57c7D2a4")
        let abiVersion = 2
        let parameters: [AnyObject] = []
        let extraData: Data = Data()
        let contract = web3.contract(contractABI, at: contractAddress, abiVersion: abiVersion)
        
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        let tx = contract?.read(contractMethod, parameters: parameters, extraData: extraData, transactionOptions: options)
        guard let value = try tx?.call() else {
            throw TransactionError.unableToReadSmartContract
        }
        print("Call Success: \(value)")
        if let valueBigUInt = value["0"] as? BigUInt {
            return "\(valueBigUInt)"
        } else {
            throw TransactionError.unableToConvertFromBigUIntToString
        }
    }
}

extension Wallet {
    var ethAddress: String {
        switch self.address {
        case .defaultAddress(let ethAddress):
            return ethAddress
        case .unknownAddress:
            return "UNKNOWN"
        }
    }
}

private extension WalletManager {
    func getWeb3Object(from network: ETHNetwork) -> web3 {
        let web3: web3
        switch network {
        case .mainnet:
            web3 = Web3.InfuraMainnetWeb3(accessToken: nil)
        case .rinkeby:
            web3 = Web3.InfuraRinkebyWeb3(accessToken: nil)
        case .kovan:
            web3 = Web3.InfuraKovanWeb3(accessToken: nil)
        case .ropsten:
            web3 = Web3.InfuraRopstenWeb3(accessToken: nil)
        }
        web3.addKeystoreManager(wallet?.getKeystoreManager())
        return web3
    }
    
    // TODO: Prepare a domain model for ERC20 token balance retrieval
    func getERC20TokenBalance(from coin: ERC20TokenCoin, network: ETHNetwork) -> ERC20TokenModel? {
        let web3 = getWeb3Object(from: .rinkeby)
        
        let ethAddress = wallet?.ethAddress ?? "UNKNOWN"
        
        let walletAddress = EthereumAddress(ethAddress)
        let exploredAddress = EthereumAddress(ethAddress)
        let erc20ContractAddress = EthereumAddress(coin.address)
        
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)
        
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        let method = "balanceOf"
        guard let tx = contract?.read(
            method,
            parameters: [exploredAddress] as [AnyObject],
            extraData: Data(),
            transactionOptions: options
        ) else {
            return nil
        }
        
        do {
            let tokenBalance = try tx.call()
            guard let balanceBigUInt: BigUInt = tokenBalance["0"] as? BigUInt else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            let balanceString = Web3.Utils.formatToEthereumUnits(balanceBigUInt, toUnits: .eth, decimals: 3)
            return .init(tokenName: coin.tokenName,
                         tokenAmount: balanceString ?? "0",
                         tokenAbbr: coin.tokenSymbol,
                         totalPrice: "undefined", //TODO: Crawl network to fetch data
                         unrealizedDiff: "undefined", //TODO: Crawl network to fetch data
                         coinType: coin)
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
    
    func getEthereumBalance(network: ETHNetwork) -> ERC20TokenModel? {
        let web3 = getWeb3Object(from: .rinkeby)
        
        let ethAddress = wallet?.ethAddress ?? "UNKNOWN"
        guard let walletAddress = EthereumAddress(ethAddress) else {
            return nil
        }
        
        do {
            let balanceResult = try web3.eth.getBalance(address: walletAddress)
            let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 3)
            
            return .init(tokenName: "Ethereum",
                         tokenAmount: balanceString!,
                         tokenAbbr: "ETH",
                         totalPrice: "undefined", //TODO: Crawl network to fetch data
                         unrealizedDiff: "undefined", //TODO: Crawl network to fetch data
                         coinType: .ethereum)
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
    
    func refreshBalance(for coin: ERC20TokenCoin, network: ETHNetwork) {
        let newBalance: ERC20TokenModel?
        if coin.isETH {
            newBalance = getEthereumBalance(network: network)
        } else {
            newBalance = getERC20TokenBalance(from: coin, network: network)
        }
        guard let newBalance = newBalance,
              let index = accounts.firstIndex(where: { $0.coinType == newBalance.coinType })
        else { return }
        
        DispatchQueue.main.async {
            print("Old balance: ", self.accounts[index])
            self.accounts.remove(at: index)
            self.accounts.insert(newBalance, at: index)
            print("New balance: ", self.accounts[index])
        }
    }
}

extension WalletManager {
    var isWalletInitialized: Bool {
        wallet != nil || isWalletBeingCreated
    }

    var isWalletBeingCreated: Bool {
        switch state {
        case .creatingWallet: return true
        default:
            return false
        }
    }
    
    var isLoading: Bool {
        self.accounts.isEmpty
    }
    
    func getBalance(from coin: ERC20TokenCoin, network: ETHNetwork) -> String {
        if coin.isETH {
            return getEthereumBalance(network: network)?.tokenAmount ?? "0"
        } else {
            return getERC20TokenBalance(from: coin, network: network)?.tokenAmount ?? "0"
        }
    }
    
    func send(from coin: ERC20TokenCoin, to address: String, amount: String, network: ETHNetwork, passphrase: String, completion: (TransactionResult) -> Void) {
        do {
            if coin.isETH {
                try sendETH(from: network, to: address, amount: amount, passphrase: passphrase) {
                    refreshBalance(for: coin, network: network)
                }
            } else {
                try sendERC20Token(coin: coin, from: network, to: address, amount: amount, passphrase: passphrase) {
                    refreshBalance(for: coin, network: network)
                }
            }
            completion(.success)
        } catch TransactionError.wrongPassphrase {
            completion(.error(.wrongPassphrase))
        }  catch TransactionError.ethTokenParameterNotValidToSend {}
        catch TransactionError.erc20TokenParametersNotValidToSend {}
        catch TransactionError.unableToSendETH {}
        catch TransactionError.unableToSendERC20Token {}
        catch TransactionError.defaultError {}
        
        catch {
            print(error.localizedDescription)
            completion(.error(.defaultError))
        }
    }
}

private extension ERC20TokenCoin {
    var isETH: Bool {
        self == .ethereum
    }
}

enum TransactionResult {
    case success
    case error(TransactionError)
}

enum TransactionError: Error {
    case unableToSendETH
    case unableToSendERC20Token
    case erc20TokenParametersNotValidToSend
    case ethTokenParameterNotValidToSend
    case wrongPassphrase
    case defaultError
    case unableToReadSmartContract
    case unableToConvertFromBigUIntToString
}
