//
//  DataTransferService.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol DataTransferErrorLogger {
    func log(error: Error)
}

final class DefaultDataTransferService {
    /// DataTransferService는 NetworkService를 주입받고
    /// 이와 비슷한 형식으로, ErrorResolver와 ErrorLogger를 주입한다
    /// 작업 시, EndPoint 객체를 인자로 사용
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    init(
        with networkService: NetworkService,
        errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
        errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

protocol DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T
}

extension DefaultDataTransferService: DataTransferService {
    
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T {

        do {
            let data = try await networkService.request(endpoint: endpoint)
            do {
                let result: T = try endpoint.responseDecoder.decode(data)
                return result
            } catch {
                self.errorLogger.log(error: error)
                throw DataTransferError.parsing(error)
            }
        } catch let error as NetworkError {
            self.errorLogger.log(error: error)
            let resolvedError = self.errorResolver.resolve(error: error)
            if resolvedError is NetworkError {
                throw DataTransferError.networkFailure(error)
            } else {
                throw DataTransferError.resolvedNetworkFailure(resolvedError)
            }
        } catch {
            throw DataTransferError.resolvedNetworkFailure(error)
        }
    }
}

// MARK: - Logger
final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() { }
    func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

// MARK: - Error Resolver
class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() { }
    func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: - Response Decoders
protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}


class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    init() { }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

class RawDataResponseDecoder: ResponseDecoder {
    init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data type"
            )
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
