//
//  WalletCoreCryptocurrencyList.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 11/5/2565 BE.
//

import SwiftUI

struct WalletCoreCryptocurrencyList: View {
    @ObservedObject var wallet: WalletCoreManager

    init(wallet: WalletCoreManager) {
        self.wallet = wallet
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }

    var body: some View {
        VStack {
            switch wallet.state {
            case .viewIsReady:
                EmptyView()
            case .loading:
                LottieView(name: "loading-animation")
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBgColor)
                
                Text("Loading")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .heavy, design: .monospaced))
            case .notEmpty:
                List {
                    ForEach(wallet.accounts) {
                        CryptocurrencyView(viewModel: .init(from: $0))
                            .listRowBackground(Color.primaryBgColor)
                            .listRowSeparator(.hidden)
                    }
                }
            case .empty:
                Text("Your address doesn't contain any coins")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .heavy, design: .monospaced))
            }
        }
        .task {
            await wallet.getERC20TokenBalances(
                address: wallet.retrieveAddress(coin: .ethereum),
                contractAddresses: [ERC20TokenCoin.chainlink.address])
        }
    }
}

struct WalletCoreCryptoCurrencyList_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoreCryptocurrencyList(wallet: .init())
    }
}
