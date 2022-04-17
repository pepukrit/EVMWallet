//
//  NetworkCaller.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 19/3/2565 BE.
//

import Foundation

struct NetworkCaller {
    
    static let shared = NetworkCaller()
    
    func call(with scRequest: GenericSCRequest, completion: @escaping (String) -> Void) async throws {
        if let url = URL(string: Key.alchemyKey) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let smartContractParam = SmartContractParam.init(to: scRequest.to, data: scRequest.data)
            let tag = "latest"
            let params: [AnyEncodable] = [.init(smartContractParam), .init(tag)]
            
            let requestNetworkEntity = ETHAlchemySmartContractRequest(
                id: 1,
                jsonrpc: "2.0",
                method: "eth_call",
                params: params
            )

            let httpBody = try JSONEncoder().encode(requestNetworkEntity)
            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(SendRawTransactionResult.self, from: data)
                        completion(result.result)
                    } catch {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                }
            }
            .resume()
        }
    }
    
    func sendTransaction(with encodedParams: String, completion: @escaping (String) -> Void) async throws {
        if let url = URL(string: Key.alchemyKey) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestNetworkEntity = ETHAlchemyRequest(
                jsonrpc: "2.0",
                method: "eth_sendRawTransaction",
                params: [encodedParams],
                id: 1
            )
            
            let httpBody = try JSONEncoder().encode(requestNetworkEntity)
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(SendRawTransactionResult.self, from: data)
                        completion(result.result)
                    } catch {
                        assertionFailure(error.localizedDescription)
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
            
            let requestNetworkEntity = ETHAlchemyRequest(
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
    
    func getTransactionCount(completion: @escaping (String?) -> Void) async throws {
        if let url = URL(string: Key.alchemyKey) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestNetworkEntity = ETHAlchemyRequest(
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
                        completion(nil)
                    }
                }
            }.resume()
        }
    }
    
    func getETHBalance(from walletAddress: String?, completion: @escaping (String) -> Void) async throws {
        if let url = URL(string: Key.alchemyKey), let walletAddress = walletAddress {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestNetworkEntity = ETHAlchemyRequest(
                jsonrpc: "2.0",
                method: "eth_getBalance",
                params: [walletAddress, "latest"],
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
            }
            .resume()
        }
    }
    
    func getTokenBalances(
        from walletAddress: String?,
        completion: @escaping ([TokenBalanceResultEntity.TokenBalanceDetailEntity.TokenBalance]?) -> Void
    ) async throws {
        if let url = URL(string: Key.alchemyKey), let walletAddress = walletAddress {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let params: [AnyEncodable] = [.init(walletAddress), .init("DEFAULT_TOKENS")]
            let requestNetworkEntity: ETHAlchemySmartContractRequest = .init(
                id: 42,
                jsonrpc: "2.0",
                method: "alchemy_getTokenBalances",
                params: params
            )
            
            let httpBody = try JSONEncoder().encode(requestNetworkEntity)
            request.httpBody = httpBody
            
            //TODO: Handle error case
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(TokenBalanceResultEntity.self, from: data)
                        let tokenBalancesEntity = result.result?.tokenBalances
                        completion(tokenBalancesEntity)
                    } catch {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                }
            }
            .resume()
        }
    }
}
