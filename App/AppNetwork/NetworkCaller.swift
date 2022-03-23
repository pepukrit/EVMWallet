//
//  NetworkCaller.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 19/3/2565 BE.
//

import Foundation

struct NetworkCaller {
    
    static let shared = NetworkCaller()
    
    func sendTransaction(with encodedParams: String, completion: @escaping (String) -> Void) async throws {
        if let url = URL(string: Key.alchemyKey) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestNetworkEntity = ETHRequest(
                jsonrpc: "2.0",
                method: "eth_sendRawTransaction",
                params: [encodedParams],
                id: 1
            )
            
            let httpBody = try JSONEncoder().encode(requestNetworkEntity)
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(SendRawTransactionResult.self, from: data)
                        completion(result.result)
                    } catch {
                        //assertionFailure(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
    func fetchGasPrice(completion: @escaping (String) -> Void) async throws {
        if let url = URL(string: Key.alchemyKey) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestNetworkEntity = ETHRequest(
                jsonrpc: "2.0",
                method: "eth_gasPrice",
                params: [],
                id: 0
            )
            
            let httpBody = try JSONEncoder().encode(requestNetworkEntity)
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(ETHResult.self, from: data)
                        completion(result.result)
                    } catch {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
    func getTransactionCount(completion: @escaping (String) -> Void) async throws {
        if let url = URL(string: Key.alchemyKey) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestNetworkEntity = ETHRequest(
                jsonrpc: "2.0",
                method: "eth_getTransactionCount",
                params: ["0x051ab25Ea6f9593c647D639E04b562A6C58c577E", "latest"],
                id: 0
            )
            
            let httpBody = try JSONEncoder().encode(requestNetworkEntity)
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(ETHResult.self, from: data)
                        completion(result.result)
                    } catch {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
}
