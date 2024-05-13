//
//  FetchRecentMovieQueriesUseCase.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation

final class FetchRecentMovieQueriesUseCase: UseCase {

    struct RequestValue {
        let maxCount: Int
    }
    private let requestValue: RequestValue
    private let moviesQueriesRepository: MoviesQueriesRepository

    init(
        requestValue: RequestValue,
        moviesQueriesRepository: MoviesQueriesRepository
    ) {
        self.requestValue = requestValue
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    func start() async throws -> [MovieQuery] {
        try await moviesQueriesRepository.fetchRecentsQueries(maxCount: requestValue.maxCount)
    }
}

protocol UseCase {
    func start() async throws -> [MovieQuery]
}
