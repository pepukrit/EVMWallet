//
//  AccountDetailViewV2.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 6/4/2565 BE.
//

import SwiftUI

struct AccountDetailViewV2: View {
    @EnvironmentObject var wallet: WalletManager
    
    var body: some View {
        VStack {
            VStack {
                HeaderView()
                
                PriceStatusView()
                
                ButtonView()
            }
            .padding(.bottom)
            .background(
                LinearGradient(
                    gradient: .init(colors: [.topShader, .lightShader]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            CryptocurrencyListV2()
                .task {
                    //TODO: WalletManagerType should be a generic one to call getTokenBalances function
                    if wallet.walletManagerType?.isWalletCoreWallet ?? false {
                        await wallet.walletCoreSwiftWallet?.getERC20TokenBalances(
                            address: wallet.address,
                            contractAddresses: [ERC20TokenCoin.chainlink.address])
                    }
                }
            
            Spacer()
        }
        .background(Color.primaryBgColor)
    }
}

struct AccountDetailViewV2_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailViewV2()
            .environmentObject(WalletManager())
    }
}
