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
        List(moviesHomeVM.movies, id: \.id){ movie in
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
        .overlay{
            if moviesHomeVM.movies.isEmpty{
                Text("Search results")
            }
            if moviesHomeVM.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
        HStack{
            VStack(alignment: .leading, spacing: 5){
                Text(movie.title ?? "")
                    .font(.headline)
                    .bold()
                Text("Release Date: \(movie.releaseDate?.toString() ?? "")")
                    .font(.subheadline)
                Text(movie.overview?.trimmed() ?? "")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            ImageView(url: url, alignment: .top)
                .frame(maxWidth: Screen.cellWidth)
        }
    }
}

#Preview {
    let container: DIContainer = .stub
    let moviesListVM: MoviesHomeViewModel = .init(container: container)
    return MoviesListView(moviesHomeVM: moviesListVM)
        .environmentObject(container)
}

// TODO: - Item이 존재하는 경우 Preview
