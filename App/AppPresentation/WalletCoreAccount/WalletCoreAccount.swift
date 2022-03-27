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
    @State var shouldShowAlertDialog: Bool = false
    @State var accountBeingCreated: Bool = false
    
    @State var passphrase: String = ""
    @State var confirmPassphrase: String = ""

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
                            walletCoreManager.createWallet(passphrase: passphrase) {
                                print("Address: \($0)")
                            }
                        }) {
                            Text("Create Wallet")
                                .font(weight: .bold)
                        }
                        .padding()
                        .background(Color.buttonBgColor)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        
                        Button(action: {
                            accountBeingCreated = true
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
                            shouldShowSendView = true
                        }) {
                            Text("Send")
                                .font(weight: .bold)
                        }
                        .padding()
                        .background(Color.buttonBgColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
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
                
                if accountBeingCreated {
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                            .onTapGesture {
                                accountBeingCreated = false
                            }
                        
                        VStack {
                            Text("Please input your password")
                                .font(with: 18, weight: .bold)
                            
                            VStack {
                                VStack(spacing: 24) {
                                    VStack {
                                        SecureField("Input your passphrase", text: $passphrase)
                                            .padding()
                                            .background(Color.primaryBgColor)
                                            .roundedClip()
                                        
                                        SecureField("Confirm your passphrase", text: $confirmPassphrase)
                                            .padding()
                                            .background(Color.primaryBgColor)
                                            .roundedClip()
                                    }
                                    .font(weight: .regular)
                                    .preferredColorScheme(.dark)
                                    
                                    Button(action: {
                                        if validatePassphrase(passphrase1: passphrase, passphrase2: confirmPassphrase) {
                                            walletCoreManager.createWallet(
                                                from: "broom switch check angry army volume sugar crane plastic asset fantasy three",
                                                passphrase: passphrase
                                            ) {
                                                print("Address: \($0)")
                                                accountBeingCreated = false
                                                
                                            }
                                        } else {
                                            shouldShowAlertDialog = true
                                        }
                                    }) {
                                        Text("Confirm")
                                            .font(weight: .bold)
                                    }
                                    .padding()
                                    .background(Color.buttonBgColor)
                                    .roundedClip()
                                }
                                .padding()
                                .background(Color.secondaryBgColor)
                                .roundedClip()
                            }
                            .padding()
                        }
                        .foregroundColor(.white)
                        .alert(isPresented: $shouldShowAlertDialog) {
                            makeAlertFrom(passphrase1: passphrase, passphrase2: confirmPassphrase)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

private extension WalletCoreAccount {
    func validatePassphrase(passphrase1: String, passphrase2: String) -> Bool {
        passphrase1 == passphrase2 && passphrase1.count > 7
    }
    
    func makeAlertFrom(passphrase1: String, passphrase2: String) -> Alert {
        if passphrase1.count > 7 || passphrase2.count > 7 {
            return .init(title: Text("Passphrase mismatched"),
                         message: Text("Please make sure you have input the correct passphrase"),
                         dismissButton: .cancel { shouldShowAlertDialog = false })
        } else {
            return .init(title: Text("Passphrase too short"),
                         message: Text("Please make sure you have input at least 8 letters long"),
                         dismissButton: .cancel { shouldShowAlertDialog = false })
        }
    }
}

struct WalletCoreAccount_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoreAccount()
            .environmentObject(WalletCoreManager())
    }
}
