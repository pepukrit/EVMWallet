//
//  WalletDomainMapper.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 1/5/2565 BE.
//

import Foundation

protocol WalletDomainMapper {
    func mapFrom(balance: ERC20TokenDetail) -> [ERC20TokenModel]
}

struct WalletDomainMapperImplementation: WalletDomainMapper {
    
    func mapFrom(balance: ERC20TokenDetail) -> [ERC20TokenModel] {
        var erc20Tokens: [ERC20TokenModel] = []
//        balance.tokenBalances.compactMap {
//            let erc20TokenModel: ERC20TokenModel = .init(tokenName: <#T##String#>,
//                                                         tokenAmount: <#T##String#>,
//                                                         tokenAbbr: <#T##String#>,
//                                                         totalPrice: "",
//                                                         unrealizedDiff: "",
//                                                         coinType: <#T##ERC20TokenCoin#>)
//        }
        
        return []
    }
}
