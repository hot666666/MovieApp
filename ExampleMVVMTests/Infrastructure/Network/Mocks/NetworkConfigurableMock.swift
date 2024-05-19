//
//  NetworkConfigurableMock.swift
//  ExampleMVVMTests
//
//  Created by 최하식 on 5/19/24.
//

import Foundation

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
