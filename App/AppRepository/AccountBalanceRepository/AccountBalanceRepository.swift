//
//  AccountBalanceRepository.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 17/4/2565 BE.
//

import Foundation

protocol AccountBalanceNetworkRepository: AnyObject {
    func getTokenBalances(
        from walletAddress: String,
        contractAddresses: [String]
    ) async -> AccountBalance?
    
    func getTokenDetail(from contractAddress: String) async -> TokenDetail?
    func getETHBalance(from walletAddress: String) async -> ETHBalance?
}

final class AccountBalanceNetworkRepositoryImplementation: AccountBalanceNetworkRepository {
    private let networkMapper: NetworkMapper
    
    init() {
        networkMapper = NetworkMapperImplementation()
    }
    
    func getTokenBalances(from walletAddress: String, contractAddresses: [String]) async -> AccountBalance? {
        do {
            let tokenBalancesEntity = try await NetworkCaller.shared.getTokenBalances(
                from: walletAddress,
                contractAddresses: contractAddresses
            )
            let accountBalance = networkMapper.mapToAccountBalance(from: tokenBalancesEntity)
            return accountBalance
        } catch {
            assertionFailure("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getTokenDetail(from contractAddress: String) async -> TokenDetail? {
        do {
            let tokenDetailResultEntity = try await NetworkCaller.shared.getTokenDetail(from: contractAddress)
            guard let symbol = tokenDetailResultEntity.result?.symbol else {
                assertionFailure("Unexpectedly not found symbol")
                return nil
            }
            let coinTokenEntity = try await NetworkCaller.shared.getTokenPriceFrom(symbol: symbol)
            let tokenDetail = networkMapper.mapToERC20Token(from: tokenDetailResultEntity, coin: coinTokenEntity)
            return tokenDetail
        } catch {
            assertionFailure("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getETHBalance(from walletAddress: String) async -> ETHBalance? {
        do {
            let result = try await NetworkCaller.shared.getETHBalance(from: walletAddress)
            let coinTokenEntity = try await NetworkCaller.shared.getTokenPriceFrom(symbol: "ETH")
            let availableEther = Double(hexStringWithEther: result.result)

            return .init(balance: availableEther,
                         rateInUSD: coinTokenEntity.rate,
                         balanceInUSD: availableEther * coinTokenEntity.rate)
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
}
