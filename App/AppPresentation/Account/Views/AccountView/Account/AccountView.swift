//
//  Account.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 25/2/2565 BE.
//

import Lottie
import SwiftUI
import WalletCore

struct AccountView: View {
    @EnvironmentObject var wallet: Web3SwiftWalletManager
    
    var body: some View {
        NavigationView {
            VStack {
                if wallet.isWalletInitialized {
                    AccountDetailView()
                } else {
                    AccountLoadingView()
                }
            }
            .background(Color.primaryBgColor)
            .navigationBarHidden(true)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(Web3SwiftWalletManager())
    }
}
