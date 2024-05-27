//
//  MoviesHomeListView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/14/24.
//

import SwiftUI

struct MoviesHomeListView: View {
    @EnvironmentObject private var container: DIContainer
    @ObservedObject var vm: MoviesHomeViewModel
    
    var body: some View {
        ScrollView {
            Divider()
            LazyVStack {
                ForEach(vm.movies, id: \.id){ movie in
                    Button(action: {
                        navigate(to: .detail(movie: movie))
                    }, label: {
                        MoviesListCellView(movie: movie)
                            .task {
                                if movie == vm.movies.last {
                                    await vm.searchMore(searchText: vm.searchText)
                                }
                            }
                    })
                }
                if vm.isLoadingMore {
                    ProgressView()
                }
            }
        }
        .overlay{
            if vm.movies.isEmpty && !vm.isLoading {
                Text("Search results")
            }
            if vm.isLoading {
                LoadingView()
            }
        }
        .foregroundColor(ColorTheme.primaryText)
    }
    
    private func navigate(to destination: NavigationDestination){
        container.navigationRouter.destinations.append(destination)
    }
}

struct MoviesListCellView: View {
    @EnvironmentObject private var container: DIContainer
    
    var movie: Movie
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(movie.title ?? "")
                        .font(.headline)
                        .bold()
                    Text("Release Date: \(movie.releaseDate?.formattedDateString ?? "")")
                        .font(.subheadline)
                    Text(movie.overview?.trimmed() ?? "")
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                
                Spacer()
                
                ImageView(url: getFullUrl(for: movie.posterPath), alignment: .top)
                    .frame(maxWidth: Screen.cellWidth)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            Divider()
        }
    }
    
    private func getFullUrl(for posterUrl: String?) -> URL? {
        container.posterImageUrlService.getFullURL(posterUrl: movie.posterPath, width: Int(Screen.cellWidth))
    }
}

#Preview("MoviesListView") {
    let container: DIContainer = .stub
    let moviesListVM: MoviesHomeViewModel = .init(container: container)
    return MoviesHomeListView(vm: moviesListVM)
        .environmentObject(container)
}

#Preview("MoviesCellView") {
    let movie: Movie = .stub()
    let container: DIContainer = .init()
    
    return MoviesListCellView(movie: movie)
        .environmentObject(container)
}
