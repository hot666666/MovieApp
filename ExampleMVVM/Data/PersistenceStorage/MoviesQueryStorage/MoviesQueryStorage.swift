//
//  MoviesQueriesStorage.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/27/24.
//

import Foundation

protocol MoviesQueryStorage {
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery]
    func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery
    func removeQuery(query: MovieQuery) async throws
}
