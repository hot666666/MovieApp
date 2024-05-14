//
//  APIEndpoints.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

struct APIEndpoints {
    /// 실제 네트워크 요청에 사용되는 Endpoint 객체를 반환
    
    static func getMovies(with moviesRequestDTO: MoviesRequestDTO) -> Endpoint<MoviesResponseDTO> {

        return Endpoint(
            path: "3/search/movie",
            method: .get,
            queryParametersEncodable: moviesRequestDTO
        )
    }

    static func getMoviePoster(path: String, width: Int) -> Endpoint<Data> {

        let sizes = [92, 154, 185, 342, 500, 780]
        let closestWidth = sizes
            .enumerated()
            .min { abs($0.1 - width) < abs($1.1 - width) }?
            .element ?? sizes.first!
        
        return Endpoint(
            path: "t/p/w\(closestWidth)\(path)",
            method: .get,
            responseDecoder: RawDataResponseDecoder()
        )
    }
}
