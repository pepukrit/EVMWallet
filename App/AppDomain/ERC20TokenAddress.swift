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
         tetherUSD,
         USDCoin,
         LUNA,
         CronosCoin
}

extension ERC20TokenCoin {
    var address: String {
        switch self {
        case .binance: return "0xB8c77482e45F1F44dE1745F52C74426C631bDD52"
        case .cardano: return "0xc14777c94229582e5758c5a79b83dde876b9be98"
        case .chainlink: return "0x01BE23585060835E02B77ef475b0Cc51aA1e0709"
        case .solana: return "0x41848d32f281383f214c69b7b248dc7c2e0a7374"
        case .avalancheCChain: return "0x93567d6b6553bde2b652fb7f197a229b93813d3f"
        case .tetherUSD: return "0xdac17f958d2ee523a2206206994597c13d831ec7"
        case .USDCoin: return "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
        case .LUNA: return "0xd2877702675e6cEb975b4A1dFf9fb7BAF4C91ea9"
        case .CronosCoin: return "0xA0b73E1Ff0B80914AB6fe0444E65848C4C34450b"
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
        case .tetherUSD: return "Tether USD"
        case .USDCoin: return "USD Coin"
        case .LUNA: return "Wrapped LUNA Token"
        case .CronosCoin: return "Cronos Coin"
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
        case .tetherUSD: return "USDT"
        case .USDCoin: return "USDC"
        case .LUNA: return "LUNA"
        case .CronosCoin: return "CRO"
        }
    }
}
