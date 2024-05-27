//
//  MoviesListViewModel.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import Foundation

class MoviesHomeViewModel: ObservableObject {
    private var useCase: DefaultSearchMoviesUseCase
    private var posterImageUrlProvider: PosterImageUrlService
    
    init(container: DIContainer) {
        self.useCase = container.searchMoviesUseCase
        self.posterImageUrlProvider = container.posterImageUrlService
    }
    
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var isSearchBarFocused: Bool = false
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private var totalPages: Int = 0
    private var page: Int = 0
}

extension MoviesHomeViewModel {
    @MainActor
    func search(searchText: String) async {
        defer {
            isLoading = false
        }
        
        page = 1
        
        do{
            isLoading = true
            await delaySeconds(secs: 0.5)
            let res = try await useCase.execute(requestValue: SearchMoviesUseCaseRequestValue(query: MovieQuery(query: searchText), page: page))
            page += 1
            totalPages = res.totalPages
            movies = res.movies
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func searchMore(searchText: String) async {
        defer {
            isLoadingMore = false
        }
        
        if page > totalPages {
            return
        }
        
        do {
            isLoadingMore = true
            await delaySeconds(secs: 0.5)
            let res = try await useCase.execute(requestValue: SearchMoviesUseCaseRequestValue(query: MovieQuery(query: searchText), page: page))
            page += 1
            movies.append(contentsOf: res.movies)
        } catch {
            print(error)
        }
    }
}

extension MoviesHomeViewModel {
    func onSearchButtonClicked(query: String){
        Task {
            await search(searchText: query)
        }
    }

    func onRecentQueryItemClicked(query: String){
        isSearchBarFocused = false
        searchText = query
        Task {
            await search(searchText: query)
        }
    }
}
