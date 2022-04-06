//
//  AccountCreationView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 12/3/2565 BE.
//

import SwiftUI

struct AccountCreationView: View {
    @EnvironmentObject var wallet: Web3SwiftWalletManager
    
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var shouldShowAlertDialog: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 32) {
                Text("The system has prepared the wallet.")
                
                Text("Please input your passphrase. This will be used to sign a transaction in further use ")
            }
            
            VStack {
                SecureField("Input your passphrase", text: $password)
                    .preferredColorScheme(.dark)
                    .padding(12)
            }
            .background(Color.secondaryBgColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            VStack {
                SecureField("Confirm your passphrase", text: $confirmPassword)
                    .preferredColorScheme(.dark)
                    .padding(12)
            }
            .background(Color.secondaryBgColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            Button(action: {
                if validatePassphrase(passphrase1: password, passphrase2: confirmPassword) {
                    DispatchQueue.global(qos: .utility).async {
                        wallet.createWallet(
                            // This is a test wallet feel free to use it
                            with: .BIP39(mnemonic: "broom switch check angry army volume sugar crane plastic asset fantasy three"),
                            passphrase: password
                        ) {
                            wallet.retrieveBalance(with: .rinkeby)
                        }
                    }
                } else {
                    shouldShowAlertDialog = true
                }
            }) {
                Text("Confirm passphrase")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
            }
            .alert(isPresented: $shouldShowAlertDialog) {
                makeAlertFrom(passphrase1: password, passphrase2: confirmPassword)
            }
            .padding()
            .background(Color.buttonBgColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
            )
            
            Divider()
            
            VStack(alignment: .leading, spacing: 32) {
                Text("Important Note: ")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                
                Text("  The application do not save your passphrase. Only the user can know the passphrase. Passphrase here can be resetted anytime. Feel free to put your passphrase you like.\n  Friendly remind, the passphrase is nothing relevant to your private key, it's just an another authentication security to let the sender sign a transaction before creating a transaction")
                    .lineSpacing(4)
                    .padding(.leading, 14)
                    .minimumScaleFactor(0.6)
            }
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            
            Spacer()
        }
        .padding()
        .padding(.top, 24)
        .font(.system(size: 16, weight: .regular, design: .monospaced))
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color.primaryBgColor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Wallet Creation"))
    }
}

private extension AccountCreationView {
    func validatePassphrase(passphrase1: String, passphrase2: String) -> Bool {
        passphrase1 == passphrase2 && passphrase1.count > 7
    }
    
    func makeAlertFrom(passphrase1: String, passphrase2: String) -> Alert {
        if passphrase1.count > 7 || passphrase2.count > 7 {
            return .init(title: Text("Passphrase mismatched"),
                         message: Text("Please make sure you have input the correct passphrase"),
                         dismissButton: .cancel { shouldShowAlertDialog = false })
        } else {
            return .init(title: Text("Passphrase too short"),
                         message: Text("Please make sure you have input at least 8 letters long"),
                         dismissButton: .cancel { shouldShowAlertDialog = false })
        }
    }
}

struct AccountCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView()
            .environmentObject(Web3SwiftWalletManager())
    }
}
