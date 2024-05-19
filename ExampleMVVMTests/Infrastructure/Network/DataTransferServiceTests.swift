//
//  DataTransferServiceTests.swift
//  ExampleMVVMTests
//
//  Created by 최하식 on 5/19/24.
//

import XCTest


class DataTransferServiceTests: XCTestCase {
    private struct MockModel: Decodable {
        let name: String
    }
    
    private enum DataTransferErrorMock: Error {
        case someError
    }
    
    func test_whenReceivedValidJsonInResponse_shouldDecodeResponseToDecodableObject() async {
        //given
        let config = NetworkConfigurableMock()
        
        let responseData = #"{"name": "Hello"}"#.data(using: .utf8)!
        
        let networkService = DefaultNetworkService(
            config: config,
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: responseData,
                error: nil
            )
        )
        
        let sut = DefaultDataTransferService(with: networkService)
        //when
        do {
            let responseData = try await sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
            //then
            XCTAssertEqual(responseData.name, "Hello")
        } catch {
            XCTFail("Failed decoding MockObject: \(error)")
        }
    }
    
    
    func test_whenInvalidResponse_shouldNotDecodeObject() async {
        //given
        let config = NetworkConfigurableMock()
        
        let responseData = #"{"age": 20}"#.data(using: .utf8)
        let networkService = DefaultNetworkService(
            config: config,
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: responseData,
                error: nil
            )
        )
        
        let sut = DefaultDataTransferService(with: networkService)
        //when
        do {
            _ = try await sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
            XCTFail("Should not happen")
        } catch let error {
            //then
            if case DataTransferError.resolvedNetworkFailure(_) = error {
                // Success
            } else {
                XCTFail("Wrong error")
            }
        }
    }
}

