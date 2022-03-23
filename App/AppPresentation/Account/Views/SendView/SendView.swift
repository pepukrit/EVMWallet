//
//  SendView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 3/3/2565 BE.
//

import Lottie
import SwiftUI

struct SendView: View {
    @EnvironmentObject var wallet: WalletManager
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
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Form {
                Section("From (Click To Copy To Clipboard)") {
                    Text(wallet.wallet?.ethAddress ?? "UNDEFINED")
                    
                    Picker(selection: $selectedTokenCoin, label: Text("Asset")) {
                        ForEach(ERC20TokenCoin.allCases, id: \.self) { token in
                            Text(token.tokenSymbol)
                        }
                    }
                    .pickerStyle(.menu)
                    .task {
                        DispatchQueue.global(qos: .utility).async {
                            totalAmount = wallet.getBalance(from: selectedTokenCoin, network: .rinkeby)
                        }
                    }
                    .onChange(of: selectedTokenCoin) { newValue in
                        DispatchQueue.global(qos: .utility).async {
                            totalAmount = wallet.getBalance(from: newValue, network: .rinkeby)
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
                            DispatchQueue.global(qos: .background).async {
                                wallet.send(from: selectedTokenCoin, to: destinationAddress, amount: destinationAmount, network: .rinkeby, passphrase: passphrase) { result in
                                    alertViewModel = makeAlertComponentFrom(result: result)
                                    shouldShowLoadingView = false
                                    shouldShowDialogDone = true
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

private extension SendView {
    
    struct AlertViewModel {
        let text: String
        let message: String
        let dismissButton: String
    }
    
    func makeAlertComponentFrom(result: TransactionResult) -> AlertViewModel {
        switch result {
        case .success:
            return .init(text: "Completed !!", message: "Your transaction is completed", dismissButton: "Done")
        case .error(let transactionError):
            switch transactionError {
            case .unableToSendETH,
                 .unableToSendERC20Token,
                 .erc20TokenParametersNotValidToSend,
                 .ethTokenParameterNotValidToSend,
                 .unableToReadSmartContract,
                 .unableToConvertFromBigUIntToString,
                 .defaultError:
                return .init(text: "Error", message: "Unexpectedly found an error before sending a transaction", dismissButton: "Done")
            case .wrongPassphrase:
                return .init(text: "Incorrect Passphrase", message: "Cannot send a transaction due to incorrect passphrase", dismissButton: "Done")
            }
        }
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

struct SendView_Previews: PreviewProvider {
    static var previews: some View {
        SendView()
            .environmentObject(WalletManager())
    }
}
