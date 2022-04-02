//
//  ContractABI.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 14/3/2565 BE.
//

enum ContractABI {
    static let box: String =
    """
    [{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"ValueChanged","type":"event"},{"inputs":[],"name":"retrieve","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"value","type":"uint256"}],"name":"store","outputs":[],"stateMutability":"nonpayable","type":"function"}]
    """
    
    static let address: String = "0x402F907757C3B745d4a809223a7251Fe57c7D2a4"
}
