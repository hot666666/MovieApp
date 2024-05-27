//
//  RecentMovieQueriesUseCase.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation

protocol RecentMoviesQueryUseCase {
    func fetch() async throws -> [MovieQuery]
    func remove(query: MovieQuery) async throws
}

final class DefaultRecentMoviesQueryUseCase: RecentMoviesQueryUseCase {

    struct RequestValue {
        let maxCount: Int
    }
    
    private let requestValue: RequestValue
    private let moviesQueriesRepository: MoviesQueryRepository

    init(
        requestValue: RequestValue,
        moviesQueriesRepository: MoviesQueryRepository
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
