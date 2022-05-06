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
    func getETHBalance(from walletAddress: String) async -> Double?
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
            let tokenDetail = networkMapper.mapToERC20Token(from: tokenDetailResultEntity)
            return tokenDetail
        } catch {
            assertionFailure("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getETHBalance(from walletAddress: String) async -> Double? {
        do {
            let result = try await NetworkCaller.shared.getETHBalance(from: walletAddress)
            let availableEther = Double(hexStringWithEther: result.result)
            return availableEther
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
}
