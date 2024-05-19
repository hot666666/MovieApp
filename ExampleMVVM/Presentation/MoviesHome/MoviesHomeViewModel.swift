//
//  MoviesListViewModel.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import Foundation

class MoviesHomeViewModel: ObservableObject{
    private var useCase: DefaultSearchMoviesUseCase
    private var posterImageUrlProvider: PosterImageUrlProvider
    
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    
    @Published var text: String = ""
    @Published var isFocusedSearchBar: Bool = false
    
    @Published var movies = [Movie]()
    
    private var page = 1
    private var totalPages = 1
    
    init(container: DIContainer) {
        self.useCase = container.searchMoviesUseCase
        self.posterImageUrlProvider = container.posterImageUrlProvider
    }
    
    @MainActor
    func search(selectedQuery: String? = nil) async {
        defer {
            isLoading = false
        }
        
        if let selectedQuery = selectedQuery {
            text = selectedQuery
        }
        
        page = 1
        
        do{
            isLoading = true
            await delaySeconds(secs: 0.5)
            let res = try await useCase.execute(requestValue: SearchMoviesUseCaseRequestValue(query: MovieQuery(query: text), page: page))
            page += 1
            totalPages = res.totalPages
            movies = res.movies
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func searchMore() async {
        defer {
            isLoadingMore = false
        }
        
        if page > totalPages {
            return
        }
        
        do {
            isLoadingMore = true
            await delaySeconds(secs: 0.5)
            let res = try await useCase.execute(requestValue: SearchMoviesUseCaseRequestValue(query: MovieQuery(query: text), page: page))
            page += 1
            movies.append(contentsOf: res.movies)
        } catch {
            print(error)
        }
    }
    
    func getURL(posterURL: String?, width: Int) -> URL? {
        do {
            if let posterURL = posterURL {
                return try posterImageUrlProvider.getURL(posterURL: posterURL, width: width)
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
