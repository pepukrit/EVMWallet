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
                
                if let walletCore = wallet.walletCoreSwiftWallet {
                    PriceStatusView(walletCore: walletCore)
                }
                
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
            
            if let walletCore = wallet.walletCoreSwiftWallet {
                WalletCoreCryptocurrencyList(wallet: walletCore)
            } else {  } //TODO: Handle web3swift wallet creation as well
            
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
