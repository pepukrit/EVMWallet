//
//  TabBarView.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 25/2/2565 BE.
//

import SwiftUI

struct TabBarView: View {
    @State private var tabSelection: Int = 1
    
    private let appearanceColor = Color(#colorLiteral(red: 0.1638098061, green: 0.1687904894, blue: 0.1730031669, alpha: 1))
    private let unselectedItemTintColor = Color(#colorLiteral(red: 0.5999999642, green: 0.6000002027, blue: 0.6043050885, alpha: 1))
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(appearanceColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(unselectedItemTintColor)
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            AccountView()
                .tabItem {
                    Label("Web3 Account", systemImage: "mail.stack")
                }
                .tag(1)
            
            MarketPlaceView()
                .tabItem {
                    Label("Smart Contract", systemImage: "newspaper.fill")
                }
                .tag(2)
            
            WalletCoreAccount()
                .environmentObject(WalletCoreManager())
                .tabItem {
                    Label("WalletCore Account", systemImage: "mail.stack.fill")
                }
                .tag(3)
        }
        .accentColor(.white)
        .preferredColorScheme(.dark)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
