//
//  MoviesQueriesRepository.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation
 
protocol MoviesQueryRepository {
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery]
    func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery
    func removeQuery(query: MovieQuery) async throws
}
