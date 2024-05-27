//
//  RecentMovieQueriesUseCase.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation

protocol UseCase {
    func fetch() async throws -> [MovieQuery]
    func remove(query: MovieQuery) async throws
}

final class DefaultRecentMovieQueriesUseCase: UseCase {

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
    
    func fetch() async throws -> [MovieQuery] {
        try await moviesQueriesRepository.fetchRecentsQueries(maxCount: requestValue.maxCount)
    }
    
    func remove(query: MovieQuery) async throws {
        try await moviesQueriesRepository.removeQuery(query: query)
    }
    
}
