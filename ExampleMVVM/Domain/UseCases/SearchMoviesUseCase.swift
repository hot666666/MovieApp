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
    private let moviesQueriesRepository: MoviesQueriesRepository

    init(
        moviesRepository: MoviesRepository,
        moviesQueriesRepository: MoviesQueriesRepository
    ) {
        self.moviesRepository = moviesRepository
        self.moviesQueriesRepository = moviesQueriesRepository
    }

    func execute(requestValue: SearchMoviesUseCaseRequestValue) async throws -> MoviesPage {
        let moviePage = try await moviesRepository.fetchMoviesList(query: requestValue.query, page: requestValue.page)
        
        let _ = try await moviesQueriesRepository.saveRecentQuery(query: requestValue.query)
        
        return moviePage
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
