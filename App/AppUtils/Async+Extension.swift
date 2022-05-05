//
//  Async+Extension.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 4/5/2565 BE.
//

import Foundation

extension Sequence {
    func asyncCompactMap<T>(
        _ transform: (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await transform(element).map { values.append($0) }
        }
        
        return values
    }
}
