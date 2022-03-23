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
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {}, label: {
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
            
            NavigationLink(destination: SendView(), isActive: $isSendPresented) {
                EmptyView()
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
