//
//  WalletCoreAccount.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 19/3/2565 BE.
//

import SwiftUI

struct WalletCoreAccount: View {
    @EnvironmentObject var walletCoreManager: WalletCoreManager
    @State var isTransactionSent: Bool = false
    
    @State var shouldShowSendView: Bool = false

    var recentSignTransaction: String? {
        walletCoreManager.encodedSignTransaction
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primaryBgColor.ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Text("Wallet Core")
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            walletCoreManager.createWallet()
                        }) {
                            Text("Create Wallet")
                                .font(weight: .bold)
                        }
                        .padding()
                        .background(Color.buttonBgColor)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        
                        Button(action: {
                            walletCoreManager.createWallet(
                                from: "broom switch check angry army volume sugar crane plastic asset fantasy three"
                            )
                        }) {
                            Text("Create Wallet With Mnemonic")
                                .font(weight: .bold)
                        }
                        .padding()
                        .background(Color.buttonBgColor)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    
                    if let wallet = walletCoreManager.wallet {
                        VStack(spacing: 16) {
                            Text("Ethereum Address:")
                            Text(wallet.getAddressForCoin(coin: .ethereum))
                        }
                        
                        if let recentSignTransaction = recentSignTransaction {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Sign Transaction data")
                                Text(recentSignTransaction)
                            }
                        }
                        
                        Button(action: {
        //                    Task {
        //                        await walletCoreManager.signTransaction {
        //                            isTransactionSent = $0
        //                        }
        //                    }
                            shouldShowSendView = true
                        }) {
                            Text("Send")
                                .font(weight: .bold)
                        }
                        .padding()
                        .background(Color.buttonBgColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .alert(isPresented: $isTransactionSent) {
                            Alert(title: Text("Confirm"),
                                  message: Text("Your transaction has been sent"),
                                  dismissButton: .cancel(Text("OK"))
                            )
                        }
                    }
                    
                    NavigationLink(destination: WalletCoreSendView(), isActive: $shouldShowSendView) {
                        EmptyView()
                    }
                    
                    Text("This Page is an attempt to use Wallet Core framework to interact with EVM")
                        .multilineTextAlignment(.center)
                        .font(with: 14, weight: .thin)
                }
                .padding()
                .font(with: 16, weight: .regular)
                .foregroundColor(.white)
            }
            .navigationBarHidden(true)
        }
    }
}

struct WalletCoreAccount_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoreAccount()
            .environmentObject(WalletCoreManager())
    }
}
