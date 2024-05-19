//
//  NetworkSessionManagerMock.swift
//  ExampleMVVMTests
//
//  Created by 최하식 on 5/19/24.
//

import Foundation

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if let data = data {
            let response = self.response ?? URLResponse()
            return (data, response)
        }
        if let response = response {
            return (Data(), response)
        }
        if let error = error {
            throw error
        }
        throw URLError(.unknown)
    }
}
