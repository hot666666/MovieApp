//
//  MovieQueriesListViewModel.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation

class MoviesQueryListViewModel: ObservableObject{
    private var useCase: RecentMoviesQueryUseCase
    
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
        
        if let res = try? await useCase.fetch(){
            queries = res
        }
    }
    
    @MainActor
    func remove(query: MovieQuery) async {
        try? await useCase.remove(query: query)
        if let index = queries.firstIndex(where: { $0.query == query.query }) {
            queries.remove(at: index)
        }
    }
}
