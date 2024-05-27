//
//  SearchMoviesUseCaseTests.swift
//  ExampleMVVMTests
//
//  Created by 최하식 on 5/19/24.
//

import XCTest

class SearchMoviesUseCaseTests: XCTestCase {
    
    static let moviesPages: [MoviesPage] = {
        let page1 = MoviesPage(page: 1, totalPages: 2, movies: [
            Movie.stub(id: "1", title: "title1", posterPath: "/1", overview: "overview1"),
            Movie.stub(id: "2", title: "title2", posterPath: "/2", overview: "overview2")])
        let page2 = MoviesPage(page: 2, totalPages: 2, movies: [
            Movie.stub(id: "3", title: "title3", posterPath: "/3", overview: "overview3")])
        return [page1, page2]
    }()
    
    enum MoviesRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    class MoviesQueryRepositoryMock: MoviesQueryRepository {
        var recentQueries: [MovieQuery] = []
        var fetchRecentsQueriesCallsCount = 0
        var removeQueryCallsCount = 0
        
        func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery] {
            fetchRecentsQueriesCallsCount += 1
            return recentQueries
        }
        
        func removeQuery(query: MovieQuery) async throws {
            removeQueryCallsCount += 1
        }
        
        func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery {
            recentQueries.append(query)
            return query
        }
    }
    
    class MoviesRepositoryMock: MoviesRepository {
        var result: MoviesPage?
        var fetchMoviesListCallsCount = 0
        
        init(result: MoviesPage?) {
            self.result = result
        }
        
        func fetchMoviesList(query: MovieQuery, page: Int) async throws -> MoviesPage {
            fetchMoviesListCallsCount += 1
            if let result = result{
                return result
            }
            throw MoviesRepositorySuccessTestError.failedFetching
        }
    }
    
    func testSearchMoviesUseCase_whenSuccessfullyFetchesMoviesForQuery_thenQueryIsSavedInRecentQueries() async throws {
        // given
        let moviesQueriesRepository = MoviesQueryRepositoryMock()
        let moviesRepository = MoviesRepositoryMock(result: SearchMoviesUseCaseTests.moviesPages[0])
        
        let useCase = DefaultSearchMoviesUseCase(
            moviesRepository: moviesRepository,
            moviesQueriesRepository: moviesQueriesRepository
        )
        
        // when
        let requestValue = SearchMoviesUseCaseRequestValue(
            query: MovieQuery(query: "title1"),
            page: 0
        )
        
        do {
            let moviesPage = try await useCase.execute(requestValue: requestValue)
            let recents = try await moviesQueriesRepository.fetchRecentsQueries(maxCount: 1)
            
            // then
            XCTAssertNotNil(moviesPage)
            XCTAssertNotNil(recents)
            XCTAssertTrue(recents.contains(MovieQuery(query: "title1")))
            XCTAssertEqual(moviesQueriesRepository.fetchRecentsQueriesCallsCount, 1)
            XCTAssertEqual(moviesRepository.fetchMoviesListCallsCount, 1)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    func testSearchMoviesUseCase_whenFailedFetchingMoviesForQuery_thenQueryIsNotSavedInRecentQueries() async throws {
        // given
        let moviesQueriesRepository = MoviesQueryRepositoryMock()
        let moviesRepository = MoviesRepositoryMock(result: nil)
        
        let useCase = DefaultSearchMoviesUseCase(
            moviesRepository: moviesRepository,
            moviesQueriesRepository: moviesQueriesRepository
        )
        
        // when
        let requestValue = SearchMoviesUseCaseRequestValue(
            query: MovieQuery(query: "title1"),
            page: 0
        )
        
        do {
            let _ = try await useCase.execute(requestValue: requestValue)
        } catch {
            // then
            let recents = try await moviesQueriesRepository.fetchRecentsQueries(maxCount: 1)
            XCTAssertFalse(recents.contains(MovieQuery(query: "title1")))
            XCTAssertEqual(moviesQueriesRepository.fetchRecentsQueriesCallsCount, 1)
            XCTAssertEqual(moviesRepository.fetchMoviesListCallsCount, 1)
        }
    }
}

