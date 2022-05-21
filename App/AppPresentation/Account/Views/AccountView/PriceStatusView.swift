//
//  PriceStatusView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import SwiftUI

struct PriceStatusView: View {
    @ObservedObject var walletCore: WalletCoreManager
    
    var body: some View {
        VStack {
            Text("$\(String(format: "%.2f", walletCore.totalPrice))")
                .font(.system(size: 36, weight: .bold, design: .monospaced))
        }
        .foregroundColor(.white)
        .padding()
    }
}
