//
//  ETHAlchemySCRequest.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 2/4/2565 BE.
//

import Foundation

struct ETHAlchemySmartContractRequest: Encodable {
    let id: Int?
    let jsonrpc: String?
    let method: String?
    let params: [AnyEncodable]
}

struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

struct SmartContractParam: Encodable {
    let to: String?
    let data: String?
}
