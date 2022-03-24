//
//  MarketPlaceView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 26/2/2565 BE.
//

import Foundation
import SwiftUI

struct MarketPlaceView: View {
    @EnvironmentObject var wallet: WalletManager
    
    @State var boxValue: String = "0"
    
    var body: some View {
        ZStack {
            Color.primaryBgColor.ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("Smart Contract")
                    .font(with: 24, weight: .bold)
                
                Text("------ Box ------")
                    .font(with: 18, weight: .bold)
                
                HStack {
                    Text("Current Box Value: \(boxValue)")
                        .font(with: 18, weight: .regular)
                }
                
                Button(action: {
                    DispatchQueue.global(qos: .utility).async {
                        do {
                            let boxValue = try wallet.readSmartContract()
                            self.boxValue = boxValue
                        } catch {
                            assertionFailure(error.localizedDescription)
                        }
                    }
                }) {
                    Text("Store")
                        .foregroundColor(.white)
                        .font(with: 18, weight: .bold)
                }
                .padding(.horizontal, 36)
                .padding(.vertical)
                .background(Color.buttonBgColor)
                .roundedClip()
                
                Text("Please create a web3swift wallet before attempting to interact with custom smart contract")
                    .padding()
                    .font(with: 14, weight: .regular)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.white)
        }
    }
}

struct MarketPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketPlaceView()
            .environmentObject(WalletManager())
    }
}
