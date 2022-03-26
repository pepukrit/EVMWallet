//
//  WalletCoreSendView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 25/3/2565 BE.
//

import SwiftUI

struct WalletCoreSendView: View {
    @EnvironmentObject var walletCoreManager: WalletCoreManager
    
    @State var selectedTokenCoin: ERC20TokenCoin = .ethereum
    @State var totalAmount: String = "0"
    
    @State var destinationAddress: String = ""
    @State var destinationAmount: String = ""
    
    @State var shouldAskPasswordConfirmation: Bool = true
    
    @State var passphrase: String = ""
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Form {
                Section("From (Click To Copy To Clipboard)") {
                    Text(walletCoreManager.retrieveAddress(coin: .ethereum))
                    
                    Picker(selection: $selectedTokenCoin, label: Text("Asset")) {
                        ForEach(ERC20TokenCoin.allCases, id: \.self) { token in
                            Text(token.tokenSymbol)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    HStack {
                        Text("Balance: ")
                        Text(totalAmount)
                        Text(" \(selectedTokenCoin.tokenSymbol)")
                    }
                }
                .listRowBackground(Color.secondaryBgColor)
                
                Section("To") {
                    TextField("ERC20 token address", text: $destinationAddress)
                        .preferredColorScheme(.dark)
                    
                    HStack {
                        Text("Amount:")
                        TextField("0", text: $destinationAmount)
                        Text("ETH")
                    }
                }
                .listRowBackground(Color.secondaryBgColor)
                
                Button(action: {
                    shouldAskPasswordConfirmation = true
                }) {
                    Text("Send")
                }
                .listRowBackground(Color.buttonBgColor)
            }
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .regular, design: .monospaced))
            .background(Color.primaryBgColor)
            .navigationTitle(Text("Send"))
            .navigationBarTitleDisplayMode(.inline)
            
            if shouldAskPasswordConfirmation {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 32) {
                        Text("Please sign a transaction using your predefined passphrase")
                        
                        HStack {
                            SecureField("Input your passphrase", text: $passphrase)
                                .padding()
                                .background(Color.primaryBgColor)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
//                                shouldShowLoadingView = true
//                                DispatchQueue.global(qos: .background).async {
//                                    wallet.send(from: selectedTokenCoin, to: destinationAddress, amount: destinationAmount, network: .rinkeby, passphrase: passphrase) { result in
//                                        alertViewModel = makeAlertComponentFrom(result: result)
//                                        shouldShowLoadingView = false
//                                        shouldShowDialogDone = true
//                                    }
//                                }
                        }) {
                            Text("Confirm")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.buttonBgColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//                            .alert(isPresented: $shouldShowDialogDone) {
//                                Alert(title: Text(alertViewModel.text),
//                                      message: Text(alertViewModel.message),
//                                      dismissButton: .default(Text(alertViewModel.dismissButton)) {
//                                    mode.wrappedValue.dismiss()
//                                })
//                            }
                    }
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .padding()
                    .background(Color.secondaryBgColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding()
                }
            }
        }
    }
}

struct WalletCoreSendView_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoreSendView()
    }
}
