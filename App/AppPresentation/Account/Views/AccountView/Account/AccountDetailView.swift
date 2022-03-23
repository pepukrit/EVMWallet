//
//  AccountDetailView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import SwiftUI

struct AccountDetailView: View {
    @EnvironmentObject var wallet: WalletManager
    
    var body: some View {
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
        
        if wallet.isLoading {
            LottieView(name: "loading-animation")
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryBgColor)
            
            Text(wallet.state.statusText)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .heavy, design: .monospaced))
        } else {
            CryptocurrencyList()
        }
        
        Spacer()
    }
}

private extension WalletManager.WalletState {
    var statusText: String {
        switch self {
        case .creatingWallet: return "The system is preparing your wallet..."
        case .fetchingBalance: return "Your Account Balance is loading..."
        case .idle: return "Everything is set !!"
        }
    }
}
