//
//  ERC20TokenAddress.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 3/3/2565 BE.
//

import Foundation

struct ERC20Token {
    let name: String
    let address: String
    let decimals: String = ""
    let symbol: String
}

enum ERC20TokenCoin: CaseIterable {
    case binance,
         cardano,
         chainlink,
         ethereum,
         solana,
         avalancheCChain,
         tether
}

extension ERC20TokenCoin {
    var address: String {
        switch self {
        case .binance: return "0xB8c77482e45F1F44dE1745F52C74426C631bDD52"
        case .cardano: return "0xc14777c94229582e5758c5a79b83dde876b9be98"
        case .chainlink: return "0x01BE23585060835E02B77ef475b0Cc51aA1e0709"
        case .solana: return "0x41848d32f281383f214c69b7b248dc7c2e0a7374"
        case .avalancheCChain: return "0x93567d6b6553bde2b652fb7f197a229b93813d3f"
        case .tether: return "0xD92E713d051C37EbB2561803a3b5FBAbc4962431"
        default:
            return ""
        }
    }
    
    var tokenName: String {
        switch self {
        case .binance: return "Binance"
        case .cardano: return "Cardano"
        case .chainlink: return "ChainLink"
        case .ethereum: return "Ethereum"
        case .solana: return "Solana"
        case .avalancheCChain: return "Avalanche"
        case .tether: return "TestUsdtToken"
        }
    }
    
    var tokenSymbol: String {
        switch self {
        case .binance: return "BNB"
        case .cardano: return "ADA"
        case .chainlink: return "LINK"
        case .ethereum: return "ETH"
        case .solana: return "SOL"
        case .avalancheCChain: return "AVAX"
        case .tether: return "TUSDT"
        }
    }
}
