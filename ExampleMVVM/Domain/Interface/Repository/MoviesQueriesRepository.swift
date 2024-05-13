//
//  MoviesQueriesRepository.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation
 
protocol MoviesQueriesRepository {
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery]

    func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery
}
