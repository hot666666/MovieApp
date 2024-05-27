//
//  DefaultMoviesQueriesRepository.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation

final class DefaultMoviesQueryRepository {
    
    private var moviesQueryPersistentStorage: MoviesQueryStorage
    
    init(moviesQueryPersistentStorage: MoviesQueryStorage) {
        self.moviesQueryPersistentStorage = moviesQueryPersistentStorage
    }
}

extension DefaultMoviesQueryRepository: MoviesQueryRepository {
    
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery] {
        try await moviesQueryPersistentStorage.fetchRecentsQueries(maxCount: maxCount)
    }
    
    func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery {
        try await moviesQueryPersistentStorage.saveRecentQuery(query: query)
    }
    
    func removeQuery(query: MovieQuery) async throws {
        try await moviesQueryPersistentStorage.removeQuery(query: query)
    }
}
