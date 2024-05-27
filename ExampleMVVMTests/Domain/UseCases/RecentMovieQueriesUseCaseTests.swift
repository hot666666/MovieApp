//
//  RecentMovieQueriesUseCaseTests.swift
//  ExampleMVVMTests
//
//  Created by 최하식 on 5/27/24.
//

import XCTest

final class DefaultRecentMoviesQueryUseCaseTests: XCTestCase {
    
    class MoviesQueryRepositoryMock: MoviesQueryRepository {
        var fetchRecentsQueriesCallsCount = 0
        var removeQueryCallsCount = 0
        
        func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery] {
            fetchRecentsQueriesCallsCount += 1
            return []
        }
        
        func removeQuery(query: MovieQuery) async throws {
            removeQueryCallsCount += 1
        }
        
        func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery {
            return query
        }
    }
    
    func testDefaultRecentMoviesQueryUseCase_whenFetchIsCalled_thenFetchesRecentQueries() async throws {
        // given
        let moviesQueriesRepository = MoviesQueryRepositoryMock()
        let useCase = DefaultRecentMoviesQueryUseCase(
            requestValue: .init(maxCount: 2),
            moviesQueriesRepository: moviesQueriesRepository
        )
        
        // when
        let _ = try await useCase.fetch()
        
        // then
        XCTAssertEqual(moviesQueriesRepository.fetchRecentsQueriesCallsCount, 1)
    }
    
    func testDefaultRecentMoviesQueryUseCase_whenRemoveIsCalled_thenRemovesQuery() async throws {
        // given
        let moviesQueriesRepository = MoviesQueryRepositoryMock()
        let useCase = DefaultRecentMoviesQueryUseCase(
            requestValue: .init(maxCount: 2),
            moviesQueriesRepository: moviesQueriesRepository
        )
        
        let query = MovieQuery(query: "test")
        let _ = try await moviesQueriesRepository.saveRecentQuery(query: query)
        
        // when
        try await useCase.remove(query: query)
        
        // then
        XCTAssertEqual(moviesQueriesRepository.removeQueryCallsCount, 1)
    }
}
