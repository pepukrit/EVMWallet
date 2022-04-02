//
//  WalletCoreSmartContractView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 1/4/2565 BE.
//

import SwiftUI

struct WalletCoreSmartContractView: View {
    @EnvironmentObject var walletCoreManager: WalletCoreManager
    
    @State var boxValue: String = ""
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
                    Task {
                        await walletCoreManager.sendTransaction(to: ContractABI.address, completion: {
                            print($0)
                        })
                    }
//                    DispatchQueue.global(qos: .utility).async {
//                        do {
//                            let boxValue = try wallet.readSmartContract()
//                            self.boxValue = boxValue
//                        } catch {
//                            assertionFailure(error.localizedDescription)
//                        }
//                    }
                }) {
                    Text("Store")
                        .foregroundColor(.white)
                        .font(with: 18, weight: .bold)
                }
                .padding(.horizontal, 36)
                .padding(.vertical)
                .background(Color.buttonBgColor)
                .roundedClip()
                
                Text("Please create a walletCore wallet before attempting to interact with custom smart contract")
                    .padding()
                    .font(with: 14, weight: .regular)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.white)
        }
    }
}

struct WalletCoreSmartContractView_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoreSmartContractView()
            .environmentObject(WalletCoreManager())
    }
}
