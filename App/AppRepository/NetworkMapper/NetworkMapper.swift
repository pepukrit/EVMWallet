//
//  NetworkMapper.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 17/4/2565 BE.
//

import Foundation

protocol NetworkMapper {
    func mapToAccountBalance(from entity: TokenBalanceResultEntity) -> AccountBalance?
    func mapToERC20Token(from entity: TokenDetailResultEntity, coin: CoinTokenResultEntity) -> TokenDetail?
}

struct NetworkMapperImplementation: NetworkMapper {
    func mapToAccountBalance(from entity: TokenBalanceResultEntity) -> AccountBalance? {
        guard let result = entity.result, let address = result.address else {
            assertionFailure("Unexpectedly retrieve result error")
            return nil
        }
        let tokenBalancesEntity = result.tokenBalances.filter { $0.error == nil }
        let tokenBalances: [TokenBalance] = tokenBalancesEntity.compactMap { .init($0) }
        return .init(address: address, tokenBalances: tokenBalances)
    }
    
    func mapToERC20Token(from entity: TokenDetailResultEntity, coin: CoinTokenResultEntity) -> TokenDetail? {
        guard let result = entity.result else {
            return nil
        }
        let name = result.name ?? ""
        let symbol = result.symbol ?? ""
        let logo = result.logo ?? ""
        let rateInUSD = coin.rate
        
        return .init(name: name,
                     symbol: symbol,
                     logo: logo,
                     rateInUSD: rateInUSD)
    }
}

private extension TokenBalance {
    init?(_ result: TokenBalanceResultEntity.TokenBalanceDetailEntity.TokenBalance) {
        guard let contractAddress = result.contractAddress, let tokenBalance = result.tokenBalance else {
            assertionFailure("Cannot map tokenBalance")
            return nil
        }
        self = .init(contractAddress: contractAddress,
                     tokenBalance: tokenBalance,
                     tokenBalanceInDouble: Double(hexStringWithEther: tokenBalance)
        )
    }
}
