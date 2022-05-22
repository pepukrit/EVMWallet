//
//  WalletCoreDepositView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 22/5/2565 BE.
//

import SwiftUI
import UniformTypeIdentifiers

struct WalletCoreDepositView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var wallet: WalletCoreManager
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account address on Ethereum chain")
                        .font(weight: .bold)
                    HStack {
                        Text("ETH Address")
                            .font(weight: .regular)
                        Spacer()
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text(wallet.retrieveAddress(coin: .ethereum))
                                .font(with: 16, weight: .bold)
                                .background(Color.secondaryBgColor)
                            
                            Spacer()
                        }
                        Button(action: {
                            UIPasteboard.general.string = wallet.retrieveAddress(coin: .ethereum)
                        }) {
                            Label("Copy to the clipboard", systemImage: "doc.on.doc.fill")
                                .font(weight: .regular)
                        }
                    }
                    .padding()
                    .roundedClip()
                }
                
                Button(action: {
                    mode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(weight: .regular)
                }
                .frame(width: proxy.size.width / 3, height: 50)
                .background(Color.buttonBgColor)
                .roundedClip()
                
                Spacer()
            }
            .padding()
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .foregroundColor(.white)
        .background(Color.primaryBgColor)
        .navigationTitle("Deposit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WalletCoreDepositView_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoreDepositView(wallet: .init())
    }
}
