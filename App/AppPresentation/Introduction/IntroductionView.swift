//
//  IntroductionView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 4/4/2565 BE.
//

import Lottie
import SwiftUI

struct IntroductionView: View {
    @EnvironmentObject var walletManager: WalletManager
    
    private var shouldNavigate: Binding<Bool> {
        Binding(get: { walletManager.walletManagerType != nil },
                set: { _ in })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primaryBgColor.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("Web3 Wallet Application")
                        .font(with: 22, weight: .bold)
                        .padding(.top)
                    
                    Group {
                        Text("There is no wallet registered yet")
                            .font(with: 16, weight: .thin)
                        
                        Button(action: {
                            walletManager.walletManagerType = .web3swift(Web3SwiftWalletManager())
                        }) {
                            Text("Create Wallet by Web3swift")
                                .font(with: 16, weight: .regular)
                                .padding()
                        }
                        .background(Color.buttonBgColor)
                        .roundedClip()
                        
                        Text("Or")
                            .font(weight: .thin)
                        
                        Button(action: {
                            walletManager.walletManagerType = .walletCore(WalletCoreManager())
                        }) {
                            Text("Create Wallet by WalletCore")
                                .font(with: 16, weight: .regular)
                                .padding()
                        }
                        .background(Color.buttonBgColor)
                        .roundedClip()
                        
                        NavigationLink(destination: AccountCreationView(), isActive: shouldNavigate) {
                            EmptyView()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
                .font(weight: .regular)
                .foregroundColor(.white)
            }
            .navigationBarHidden(true)
        }
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
