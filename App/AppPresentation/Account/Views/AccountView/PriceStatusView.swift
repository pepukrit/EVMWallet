//
//  PriceStatusView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import SwiftUI

struct PriceStatusView: View {
    var body: some View {
        VStack {
            Text("$999,999")
                .font(.system(size: 48, weight: .bold, design: .monospaced))

            HStack {
                Text("+$5,999")

                Text("+9.99%")
            }
            .font(.system(size: 18, weight: .semibold, design: .monospaced))
            .foregroundColor(.green)
            .padding(.horizontal)
        }
        .foregroundColor(.white)
        .padding()
    }
}
