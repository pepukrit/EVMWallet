//
//  HeaderViewV2.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 6/4/2565 BE.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var wallet: WalletManager
    
    var body: some View {
        HStack {
            Image(systemName: "square.stack.3d.up")
                .font(.system(size: 24))
            
            Spacer()
            
            VStack {
                Text("Account")
                Text(wallet.address)
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

struct HeaderViewV2_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .environmentObject(WalletManager())
    }
}
