//
//  NetworkService.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkService {
    func request(endpoint: Requestable) async throws -> Data
}

protocol NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

final class DefaultNetworkService {
    /// NetworkService 계층에서 외부에서 request 메서드 사용은 Requestable를 인자를 사용하고, 내부에선 URLReqeust를 만들어 사용한다
    /// 이때 URLRequest를 이용한 요청은 NetworkSessionManger에 의해 수행되는데
    /// 즉, 이부분은 추후 다른 라이브러리를 사용해야할 때, 갈아끼우면 된다(ErrorLogger도 마찬가지)
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
    ) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func request(request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await sessionManager.request(request)
            self.logger.log(responseData: data, response: response)
            return data
        } catch {
            let networkError = self.resolve(error: error)
            self.logger.log(error: networkError)
            throw networkError
        }
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    func request(endpoint: Requestable) async throws -> Data {
        let urlRequest = try endpoint.urlRequest(with: config)
        return try await request(request: urlRequest)
    }
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await URLSession.shared.data(for: request)
        return (data, response)
    }
}

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }

    func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {
        printIfDebug("\(error)")
    }
}
