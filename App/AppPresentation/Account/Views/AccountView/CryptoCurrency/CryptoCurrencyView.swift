//
//  CryptoCurrencyView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 5/3/2565 BE.
//

import SwiftUI

struct CryptocurrencyView: View {
    let viewModel: ERC20TokenViewModel
    
    var body: some View {
        HStack {
            Image(viewModel.image)
                .resizable()
                .clipShape(Circle())
                .frame(width: 35, height: 35)
            VStack(alignment: .leading) {
                Text(viewModel.tokenName)
                    .foregroundColor(.white)
                Text("\(viewModel.tokenAmount) \(viewModel.tokenSymbol)")
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(viewModel.totalPrice)
                    .foregroundColor(.white)
                Text(viewModel.unrealizedDiff)
                    .foregroundColor(.green)
            }
            
        }
        .padding()
        .font(.system(size: 16, weight: .regular, design: .monospaced))
        .background(Color.secondaryBgColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct CryptocurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CryptocurrencyView(viewModel: .init(image: "", tokenName: "Bitcoin", tokenAmount: "10.00", tokenSymbol: "BTC", totalPrice: "30,000.00043854278439487", unrealizedDiff: ""))
            .padding()
    }
}
