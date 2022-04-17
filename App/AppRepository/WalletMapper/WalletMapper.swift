//
//  WalletMapper.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 15/4/2565 BE.
//

import Foundation

protocol WalletMapper {
    func mapERC20TokenAddress(
        from contractAddress: String,
        balance: String
    ) -> ERC20TokenModel?
}

struct WalletMapperImplementation: WalletMapper {
    
    func mapERC20TokenAddress(from contractAddress: String, balance: String) -> ERC20TokenModel? {
        if let tokenCoin = findERC20TokenCoin(from: contractAddress) {
            let tokenAmount = String(Double(hexStringWithEther: balance))
            return .init(tokenName: tokenCoin.tokenName,
                         tokenAmount: tokenAmount,
                         tokenAbbr: tokenCoin.tokenSymbol,
                         totalPrice: "Unknown", //TODO: Find a way to fetch price from tokenPrice
                         unrealizedDiff: "Unknown", //TODO: Find a way to fetch unrealized diff
                         coinType: tokenCoin)
        } else {
            return nil
        }
    }
}

private extension WalletMapperImplementation {
    func findERC20TokenCoin(from address: String) -> ERC20TokenCoin? {
        guard let ERC20TokenCoin = ERC20TokenCoin.allCases.first(where: { $0.address == address} ) else {
            //assertionFailure("Unexpectedly found unknown ERC20token address")
            return nil
        }
        return ERC20TokenCoin
    }
}
