//
//  MainApp.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 25/2/2565 BE.
//

import SwiftUI

@main
struct NFTWalletApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(WalletManager())
                .environmentObject(WalletCoreManager())
        }
    }
}
