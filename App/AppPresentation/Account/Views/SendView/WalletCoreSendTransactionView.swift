//
//  WalletCoreSendTransactionView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 11/5/2565 BE.
//

import Lottie
import SwiftUI

struct WalletCoreSendTransactionView: View {
    let wallet: WalletCoreManager
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State fileprivate var alertViewModel: AlertViewModel!
    
    @State var selectedTokenCoin: ERC20TokenCoin = .ethereum
    @State var totalAmount: String = "0"
    @State var destinationAddress: String = "0x990a2CF2072d24c3663f4C9CAf5CE7829b1A2d0a"
    @State var destinationAmount: String = "0"
    
    @State var passphrase: String = ""
    @State var shouldAskPasswordConfirmation: Bool = false
    
    @State var shouldShowLoadingView: Bool = false
    @State var shouldShowDialogDone: Bool = false
    
    init(wallet: WalletCoreManager) {
        self.wallet = wallet
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            let address = wallet.retrieveAddress(coin: .ethereum)
            Form {
                Section("From (Click To Copy To Clipboard)") {
                    Text(address)
                    
                    Picker(selection: $selectedTokenCoin, label: Text("Asset")) {
                        ForEach(ERC20TokenCoin.allCases, id: \.self) { token in
                            Text(token.tokenSymbol)
                        }
                    }
                    .pickerStyle(.menu)
                    .task {
                        totalAmount = wallet.accounts.first(where: { $0.coinType == .ethereum })?.tokenAmount ?? "0"
                    }
                    .onChange(of: selectedTokenCoin) { newValue in
                        if let selectedTokenAccount = wallet.accounts.first(where: { $0.coinType == newValue }) {
                            totalAmount = selectedTokenAccount.tokenAmount
                        }
                    }
                    
                    HStack {
                        Text("Balance: ")
                        Text(totalAmount)
                        Text(" \(selectedTokenCoin.tokenSymbol)")
                    }
                }
                .foregroundColor(.white)
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
                .foregroundColor(.white)
                .listRowBackground(Color.secondaryBgColor)
                
                Button(action: {
                    shouldAskPasswordConfirmation = true
                }) {
                    Text("Send")
                        .foregroundColor(.white)
                }
                .listRowBackground(Color.buttonBgColor)
            }
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
                            shouldShowLoadingView = true
                            Task {
                                guard let destinationAmount = Double(destinationAmount) else {
                                    return
                                }
                                if selectedTokenCoin == .ethereum {
                                    await wallet.sendTransaction(with: destinationAmount, address: destinationAddress) { result in
                                        alertViewModel = makeAlertComponentFrom(result: result)
                                        shouldShowLoadingView = false
                                        shouldShowDialogDone = true
                                    }
                                }
                            }
                        }) {
                            Text("Confirm")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.buttonBgColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .alert(isPresented: $shouldShowDialogDone) {
                            Alert(title: Text(alertViewModel.text),
                                  message: Text(alertViewModel.message),
                                  dismissButton: .default(Text(alertViewModel.dismissButton)) {
                                mode.wrappedValue.dismiss()
                            })
                        }
                    }
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .padding()
                    .background(Color.secondaryBgColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding()
                }
            }
            
            if shouldShowLoadingView {
                LottieView(name: "loading-animation")
                    .padding()
                    .background(Color.primaryBgColor.opacity(0.7))
            }
        }
    }
}

private extension WalletCoreSendTransactionView {
    
    struct AlertViewModel {
        let text: String
        let message: String
        let dismissButton: String
    }
    
    func makeAlertComponentFrom(result: Bool) -> AlertViewModel {
        result
        ? .init(text: "Completed !!", message: "Your transaction is completed", dismissButton: "Done")
        : .init(text: "Error", message: "Unexpectedly found an error before sending a transaction", dismissButton: "Done")
    }
}

private extension TransactionResult {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .error: return false
        }
    }
}

struct WalletCoreSendTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoreSendTransactionView(wallet: .init())
    }
}
