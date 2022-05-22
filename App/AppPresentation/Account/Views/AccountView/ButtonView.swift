//
//  ButtonView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import SwiftUI

struct ButtonView: View {
    @EnvironmentObject var wallet: WalletManager
    @State var isSendPresented: Bool = false
    @State var isDepositPresented: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: { isDepositPresented = true }, label: {
                Text("Deposit")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding()
            })
                .frame(maxWidth: .infinity)
                .background(Color.buttonBgColor)
                .clipShape(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                )
            
            if let wallet = wallet.walletCoreSwiftWallet {
                NavigationLink(destination: WalletCoreSendTransactionView(wallet: wallet),
                               isActive: $isSendPresented) {
                    EmptyView()
                }
                NavigationLink(destination: WalletCoreDepositView(wallet: wallet),
                               isActive: $isDepositPresented) {
                    EmptyView()
                }
            } else {
                NavigationLink(destination: Web3SwiftSendView(), isActive: $isSendPresented) {
                    EmptyView()
                }
            }
            
            Button(action: {
                isSendPresented = true
            }, label: {
                Text("Send")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding()
            })
                .frame(maxWidth: .infinity)
                .background(Color.buttonBgColor)
                .clipShape(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                )
        }
        .padding(.horizontal)
    }
}
