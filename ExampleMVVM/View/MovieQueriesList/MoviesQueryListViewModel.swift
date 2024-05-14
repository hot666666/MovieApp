//
//  MovieQueriesListViewModel.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation

class MoviesQueryListViewModel: ObservableObject{
    private var useCase: FetchRecentMovieQueriesUseCase
    
    @Published var queries = [MovieQuery]()
    @Published var isLoading = false
    
    init(container: DIContainer) {
        self.useCase = container.moviesQueriesUseCase
    }
    
    @MainActor
    func fetch() async {
        defer {
            isLoading = false
        }
        
        isLoading = true
        if let res = try? await useCase.start(){
            queries = res
        }
    }
}
