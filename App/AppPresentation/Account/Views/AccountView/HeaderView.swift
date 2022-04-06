//
//  HeaderVew.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var wallet: Web3SwiftWalletManager
    
    var body: some View {
        HStack {
            Image(systemName: "square.stack.3d.up")
                .font(.system(size: 24))
            
            Spacer()
            
            VStack {
                Text("Account")
                Text(wallet.wallet?.ethAddress ?? "Unidentified")
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .font(.system(size: 16, weight: .light, design: .monospaced))
            .padding(.horizontal)
            
            Spacer()
            
            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 24))
        }
        .foregroundColor(.white)
        .padding()
    }
}
