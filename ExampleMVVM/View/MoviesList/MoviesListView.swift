//
//  MoviesListView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/14/24.
//

import SwiftUI

struct MoviesListView: View {
    @EnvironmentObject private var container: DIContainer
    @ObservedObject var moviesHomeVM: MoviesHomeViewModel
    
    var body: some View {
        ScrollView {
            Divider()
            LazyVStack {
                ForEach(moviesHomeVM.movies, id: \.id){ movie in
                    Button(action: {
                        container.navigationRouter.destinations.append(.detail(movie: movie, url: getURLForDetail(movie: movie)))
                    }, label: {
                        MoviesListCellView(movie: movie, url: getURLForCell(movie: movie))
                            .task {
                                if movie == moviesHomeVM.movies.last {
                                    await moviesHomeVM.searchMore()
                                }
                            }
                    })
                }
                if moviesHomeVM.isLoadingMore {
                    ProgressView()
                }
            }
        }
        .overlay{
            if moviesHomeVM.movies.isEmpty && !moviesHomeVM.isLoading {
                Text("Search results")
            }
            if moviesHomeVM.isLoading {
                LoadingView()
            }
        }
        .foregroundColor(ColorTheme.primaryText)
    }
    
    func getURLForCell(movie: Movie) -> URL? {
        return moviesHomeVM.getURL(posterURL: movie.posterPath, width: Int(Screen.cellWidth))
    }

    func getURLForDetail(movie: Movie) -> URL? {
        return moviesHomeVM.getURL(posterURL: movie.posterPath, width: Int(Screen.detailWidth))
    }
}

struct MoviesListCellView: View {
    var movie: Movie
    var url: URL?
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(movie.title ?? "")
                        .font(.headline)
                        .bold()
                    Text("Release Date: \(movie.releaseDate?.toString() ?? "")")
                        .font(.subheadline)
                    Text(movie.overview?.trimmed() ?? "")
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                
                Spacer()
                
                ImageView(url: url, alignment: .top)
                    .frame(maxWidth: Screen.cellWidth)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            Divider()
        }
    }
}

// TODO: - Item이 존재하는 경우 Preview
#Preview("MoviesListView") {
    let container: DIContainer = .stub
    let moviesListVM: MoviesHomeViewModel = .init(container: container)
    return MoviesListView(moviesHomeVM: moviesListVM)
        .environmentObject(container)
}

#Preview("MoviesCellView") {
    let movie: Movie = .stub()
    let container: DIContainer = .init()
    let provider = container.posterImageUrlProvider
    let url = try? provider.getURL(posterURL: movie.posterPath!, width: 200)
    
    return MoviesListCellView(movie: movie, url: url)
}
