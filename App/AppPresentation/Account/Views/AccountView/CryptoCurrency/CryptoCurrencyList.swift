//
//  CryptoCurrencyList.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import SwiftUI

struct CryptocurrencyList: View {
    @EnvironmentObject var wallet: Web3SwiftWalletManager
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        List {
            ForEach(wallet.accounts) {
                CryptocurrencyView(viewModel: .init(from: $0))
                    .listRowBackground(Color.primaryBgColor)
            }
        }
    }
}

struct WalletCoreCryptocurrencyList: View {
    @ObservedObject var wallet: WalletCoreManager

    init(wallet: WalletCoreManager) {
        self.wallet = wallet
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }

    var body: some View {
        VStack {
            if !wallet.accounts.isEmpty {
                List {
                    ForEach(wallet.accounts) {
                        CryptocurrencyView(viewModel: .init(from: $0))
                            .listRowBackground(Color.primaryBgColor)
                    }
                }
            } else {
                Text("Oops ! Something went wrong")
                    .font(with: 16, weight: .bold)
            }
        }
        .task {
            await wallet.getERC20TokenBalances(
                address: wallet.retrieveAddress(coin: .ethereum),
                contractAddresses: [ERC20TokenCoin.chainlink.address])
        }
    }
}
