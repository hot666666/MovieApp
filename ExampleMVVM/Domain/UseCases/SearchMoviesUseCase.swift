//
//  SearchMoviesUseCase.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/11/24.
//

import Foundation

protocol SearchMoviesUseCase {
    func execute(requestValue: SearchMoviesUseCaseRequestValue) async throws -> MoviesPage
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {

    private let moviesRepository: MoviesRepository

    init(
        moviesRepository: MoviesRepository
    ) {
        self.moviesRepository = moviesRepository
    }

    func execute(requestValue: SearchMoviesUseCaseRequestValue) async throws -> MoviesPage {
        return try await moviesRepository.fetchMoviesList(query: requestValue.query, page: requestValue.page)
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
