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

struct CryptocurrencyListV2: View {
    @EnvironmentObject var wallet: WalletManager

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
