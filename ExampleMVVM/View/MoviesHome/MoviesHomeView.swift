//
//  ContentView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import SwiftUI

struct MoviesHomeView: View {
    @EnvironmentObject private var container: DIContainer
    @ObservedObject var moviesHomeVM: MoviesHomeViewModel
    @ObservedObject var movieQueriesListVM: MoviesQueryListViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            VStack(spacing: 0){
                HeaderView(title: "Movies")
                
                SearchBarView(moviesListVM: moviesHomeVM, defocus: defocus)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        Task{
                            await moviesHomeVM.search()
                        }
                    }
                
                BodyView()
            }
            .onChange(of: isTextFieldFocused){ _, newValue in
                withAnimation{
                    moviesHomeVM.isFocusedSearchBar = newValue
                }
            }
            .onAppear{
                moviesHomeVM.isFocusedSearchBar = isTextFieldFocused
            }
            .navigationDestination(for: NavigationDestination.self){ dest in
                switch dest {
                case let .detail(movie, url):
                    MoviesDetailsView(movie: movie, url: url)
                }
            }
        }
    }
    
    @ViewBuilder
    func BodyView() -> some View {
        if moviesHomeVM.isFocusedSearchBar {
            MoviesQueryListView(movieQueriesVM: movieQueriesListVM, movieListVM: moviesHomeVM, defocus: defocus)
        } else {
            MoviesListView(moviesHomeVM: moviesHomeVM)
        }
    }
    
    func defocus(){
        isTextFieldFocused = false
    }
}

#Preview("MoviesHomeView") {
    let container: DIContainer = .init()
    
    return MoviesHomeView(moviesHomeVM: .init(container: container), movieQueriesListVM: .init(container: container))
        .environmentObject(container)
}

//#Preview("MoviesListCellView") {
//    MoviesListCellView(movie: .stub()) { str, int in
//        return nil
//    }
//}
