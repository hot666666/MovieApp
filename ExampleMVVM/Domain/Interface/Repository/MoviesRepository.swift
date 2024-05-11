//
//  MoviesRepository.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

protocol MoviesRepository {
    func fetchMoviesList(
        query: MovieQuery,
        page: Int
//        cached: @escaping (MoviesPage) -> Void,
    ) async throws -> MoviesPage 
}
