//
//  WalletCoreSendView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 25/3/2565 BE.
//

import SwiftUI

struct WalletCoreSendView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var walletCoreManager: WalletCoreManager
    
    @State var selectedTokenCoin: ERC20TokenCoin = .ethereum
    @State var totalAmount: String = "0"
    
    @State var destinationAddress: String = "0x990a2CF2072d24c3663f4C9CAf5CE7829b1A2d0a"
    @State var destinationAmount: String = ""
    
    @State var destinationAmountInvalid: Bool = false
    @State var isTransactionSent: Bool = false
    @State var shouldAskPasswordConfirmation: Bool = false
    @State var shouldShowAlertDialog: Bool = false
    
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
                        .onAppear {
                            Task {
                                let ethBalance = await walletCoreManager.retrieveETHBalance()
                                totalAmount = String(format: "%.3f", ethBalance) // format double with 3 decimal places
                            }
                        }
                        .onChange(of: selectedTokenCoin) { coin in
                            Task {
                                let ethBalance = await walletCoreManager.retrieveETHBalance()
                                totalAmount = String(format: "%.3f", ethBalance) // format double with 3 decimal places
                            }
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
                .alert(isPresented: $isTransactionSent) {
                    Alert(title: Text("Confirm"),
                          message: Text("Your transaction has been sent"),
                          dismissButton: .cancel(Text("OK")) {
                        mode.wrappedValue.dismiss()
                    })
                }
            }
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .regular, design: .monospaced))
            .background(Color.primaryBgColor)
            .navigationTitle(Text("Send"))
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $destinationAmountInvalid) {
                Alert(title: Text("Cannot send a transaction"),
                      message: Text("Ayoo, you try to send \(destinationAmount.isEmpty ? "0" : destinationAmount) eth !"),
                      dismissButton: .cancel(Text("Try Again"), action: { destinationAmountInvalid = false }))
            }
            
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
                            do {
                                let keyChainPassphrase = try KeyChainManager.shared.getGenericPasswordFor(
                                    address: walletCoreManager.retrieveAddress(coin: .ethereum)
                                )
                                if passphrase == keyChainPassphrase {
                                    if let ether = Double(destinationAmount) {
                                        Task {
                                            await walletCoreManager.sendTransaction(with: ether, address: destinationAddress) {
                                                isTransactionSent = $0
                                            }
                                        }
                                    } else {
                                        destinationAmountInvalid = true
                                    }
                                } else {
                                    shouldShowAlertDialog = true
                                }
                                
                            } catch {
                                assertionFailure(error.localizedDescription)
                            }
                        }) {
                            Text("Confirm")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.buttonBgColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .padding()
                    .background(Color.secondaryBgColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding()
                    .alert(isPresented: $shouldShowAlertDialog) {
                        makeAlertPassphraseMismatched()
                    }
                }
            }
        }
    }
}

private extension WalletCoreSendView {
    func makeAlertPassphraseMismatched() -> Alert {
        .init(title: Text("Cannot sign a transaction"),
              message: Text("Your passphrase is incorrect"),
              dismissButton: .cancel(Text("Confirm")) {
            shouldShowAlertDialog = false
            shouldAskPasswordConfirmation = false
        })
    }
}

struct WalletCoreSendView_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoreSendView()
    }
}
