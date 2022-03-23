//
//  AccountLoadingView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import SwiftUI

struct AccountLoadingView: View {
    @EnvironmentObject var wallet: WalletManager
    
    @State var shouldNavigate: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                Text("There is no wallet registered yet")
                    .font(with: 16, weight: .thin)
                
                Button(action: { shouldNavigate = true }) {
                    Text("Create Wallet")
                        .font(with: 16, weight: .regular)
                        .padding()
                }
                .background(Color.secondaryBgColor)
                
                NavigationLink(destination: AccountCreationView(), isActive: $shouldNavigate) {
                    EmptyView()
                }
                
                Text("This Page is an attempt to use web3swift framework to interact with EVM")
                    .multilineTextAlignment(.center)
                    .font(with: 14, weight: .thin)
            }
            .padding()
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .foregroundColor(.white)
        .background(Color.primaryBgColor)
    }
}

struct AccountLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        AccountLoadingView()
            .environmentObject(WalletManager())
    }
}
