//
//  DefaultMoviesQueriesRepository.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation

final class DefaultMoviesQueryRepository {
    
    private var moviesQueriesPersistentStorage: MoviesQueriesStorage
    
    init(moviesQueriesPersistentStorage: MoviesQueriesStorage) {
        self.moviesQueriesPersistentStorage = moviesQueriesPersistentStorage
    }
}

extension DefaultMoviesQueryRepository: MoviesQueryRepository {
    
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery] {
        try await moviesQueriesPersistentStorage.fetchRecentsQueries(maxCount: maxCount)
    }
    
    func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery {
        try await moviesQueriesPersistentStorage.saveRecentQuery(query: query)
    }
    
    func removeQuery(query: MovieQuery) async throws {
        try await moviesQueriesPersistentStorage.removeQuery(query: query)
    }
}
